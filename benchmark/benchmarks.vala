/* benchmarks.vala - A single-file benchmark utility
 *
 * deps:
 *  * glib-2.0
 *  * gobject-2.0
 *  * posix
 *
 * Written in 2018 by kosmolot (kosmolot17@yandex.com)
 *
 * To the extent possible under law, the author have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 legalcode along with this
 * work. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

namespace Benchmarks {
	/* public methods */

	public Group benchmark (uint warming_up, Func<Reporter> setup) {
		ReporterImpl reporter = new ReporterImpl();
		setup(reporter);
		reporter.run(warming_up);
		return reporter;
	}

	/* definitions */

	public interface Reporter : Object {
		public abstract void report (owned string label, owned Func<Stopwatch> job);
		public abstract void group (owned string label, Func<Reporter> setup);
		public abstract bool is_warming_up { get; }
	}

	public interface Stopwatch : Object {
		public abstract void start ();
		public abstract void stop ();
		public abstract void notate (owned string note);
	}

	public interface Group : Object {
		public abstract string label { get; }
		public abstract Group? parent { get; }
		public abstract bool has_report (string label);
		public abstract bool has_group (string label);
		public abstract Report get_report (string label);
		public abstract Group get_group (string label);
		public abstract Report[] get_reports ();
		public abstract Group[] get_groups ();
	}

	public interface Report : Object {
		public abstract string label { get; }
		public abstract double monotonic_time { get; }
		public abstract double real_time { get; }
		public abstract string note { get; }
	}

	/* implementations */

	private const string CLEAR_LINE = "\033[2K\r";

	private class ReporterImpl : Object, Reporter, Group {
		private const int DECIMAL_PLACES = 6;
		private const string ROOT_GROUP_NAME = "root";
		private const string HEADER_INDENT = " - ";
		private const string INDENT = "   ";
		private const string GROUP_SUFFIX = ")";
		private const string LABEL_SUFFIX = ":";
		private const string LABEL_TOTAL = "*total";
		private const string LABEL_AVG = "*avg";
		private const string TIME_SUFFIX = "s";
		private const string MONOTONIC_TIME_TITLE = "monotonic";
		private const string REAL_TIME_TITLE = "real";

		private GenericArray<ReportImpl> _reports;
		private HashTable<string,int> _report_names; // <name, index>
		private GenericArray<ReporterImpl> _children;
		private HashTable<string,int> _child_names; // <name, index>

		private string _label;
		private unowned ReporterImpl? _parent;
		private bool _is_warming_up;

		public ReporterImpl (owned string? label = null, ReporterImpl? parent = null) {
			_label = label == null ? ROOT_GROUP_NAME : ((owned) label);
			_parent = parent;
			_reports = new GenericArray<ReportImpl>();
			_report_names = new HashTable<string,int>(str_hash, str_equal);
			_children = new GenericArray<ReporterImpl>();
			_child_names = new HashTable<string,int>(str_hash, str_equal);
		}

		public void report (owned string label, owned Func<Stopwatch> job) {
			if (label in _report_names) {
				error(@"Duplicated report name '$label'");
			}
			int idx = _reports.length;
			_report_names[label] = idx;
			var report = new ReportImpl((owned) label, (owned) job);
			_reports.add(report);
		}

		public void group (owned string label, Func<Reporter> setup) {
			if (label in _child_names) {
				error(@"Duplicated group name '$label'");
			}
			int idx = _children.length;
			_child_names[label] = idx;
			var child = new ReporterImpl((owned) label, this);
			_children.add(child);
			setup(child);
		}

		public bool is_warming_up {
			get {
				return _is_warming_up;
			}
		}

		public string label {
			get {
				return _label;
			}
		}

		public Group? parent {
			get {
				return _parent;
			}
		}

		public uint num_total_reports {
			get {
				uint len = _reports.length;
				_children.foreach((g) => len += g.num_total_reports);
				return len;
			}
		}

		public bool has_report (string label) {
			return _report_names.contains(label);
		}

		public bool has_group (string label) {
			return _child_names.contains(label);
		}

		public Report get_report (string label) {
			if (label in _report_names) {
				error(@"Report '$label' not found");
			}
			return _reports[_report_names[label]];
		}

		public Group get_group (string label) {
			if (label in _child_names) {
				error(@"Group '$label' not found");
			}
			return _children[_child_names[label]];
		}

		public Report[] get_reports () {
			Report[] array = new Report[_reports.length];
			for (int i = 0, n = array.length; i < n; i++) {
				array[i] = _reports[i];
			}
			return array;
		}

		public Group[] get_groups () {
			Group[] array = new Group[_children.length];
			for (int i = 0, n = array.length; i < n; i++) {
				array[i] = _children[i];
			}
			return array;
		}

		public void run (uint warming_up) {
			uint total = num_total_reports * (warming_up + 1);
			ProgressHelper p = new ProgressHelper(total);
			for (uint i = 0; i < warming_up; i++) {
				warm_up(p);
			}
			run_real_benchmark(p);
			if ( Posix.isatty(Posix.stdout.fileno()) ) print("%s", CLEAR_LINE);
			print_result();
		}

		private void warm_up (ProgressHelper p) {
			_is_warming_up = true;
			_reports.foreach((g) => {
				p.progress();
				g.measure();
			});
			_children.foreach((g) => g.warm_up(p));
			_is_warming_up = false;
		}

		private void run_real_benchmark (ProgressHelper p) {
			_reports.foreach((g) => {
				p.progress();
				g.measure();
			});
			_children.foreach((g) => g.run_real_benchmark(p));
		}

		private void print_result (uint depth = 0) {
			uint len = _reports.length;
			if (len == 0) {
				print("%s%s\n", header_indent(depth), _label + GROUP_SUFFIX);
			} else {
				var sorted_reports = get_sorted_reports();
				double fastest = sorted_reports[0].real_time;

				string group_label = _label + GROUP_SUFFIX;
				string total_label = LABEL_TOTAL + LABEL_SUFFIX;
				string avg_label = LABEL_AVG + LABEL_SUFFIX;

				int label_width = group_label.length;
				label_width = int.max(label_width, total_label.length);
				label_width = int.max(label_width, avg_label.length);

				int time_width = MONOTONIC_TIME_TITLE.length;
				time_width = int.max(time_width, REAL_TIME_TITLE.length);
				string time_format = @"%.$(DECIMAL_PLACES)f$(TIME_SUFFIX)";
				double m_total = 0;
				double r_total = 0;
				sorted_reports.foreach((report) => {
					int lw = report.label.length + LABEL_SUFFIX.length;
					int mw = time_format.printf(report.monotonic_time).length;
					int rw = time_format.printf(report.real_time).length;
					if (label_width < lw) label_width = lw;
					if (time_width < mw) time_width = mw;
					if (time_width < rw) time_width = rw;
					m_total += report.monotonic_time;
					r_total += report.real_time;
				});
				int mw = time_format.printf(m_total).length;
				int rw = time_format.printf(r_total).length;
				if (time_width < mw) time_width = mw;
				if (time_width < rw) time_width = rw;

				string hidt = header_indent(depth);
				string header_format = @"$(hidt)%-$(label_width)s   %$(time_width)s   %$(time_width)s\n";
				print(header_format, group_label, MONOTONIC_TIME_TITLE, REAL_TIME_TITLE);

				string idt = indent(depth);
				string body_format = @"$(idt)%-$(label_width)s   $(time_format)   $(time_format)%s%s\n";
				sorted_reports.foreach((report) => {
					string multiple = fastest == report.real_time || fastest == 0 ? "" : "   %.2fx slower".printf(report.real_time / fastest);
					string note = report.note.length == 0 ? "" : "   " + report.note;
					print(body_format, report.label + LABEL_SUFFIX, report.monotonic_time, report.real_time, multiple, note);
				});

				print(body_format, total_label, m_total, r_total, "", "");
				double m_avg = m_total / len;
				double r_avg = r_total / len;
				print(body_format, avg_label, m_avg, r_avg, "", "");
			}
			_children.foreach((g) => g.print_result(depth + 1));
		}

		private string header_indent (uint depth) {
			StringBuilder buf = new StringBuilder();
			for (uint i = 0; i < depth; i++) {
				buf.append(HEADER_INDENT);
			}
			return buf.str;
		}

		private string indent (uint depth) {
			StringBuilder buf = new StringBuilder();
			for (uint i = 0; i < depth; i++) {
				buf.append(INDENT);
			}
			return buf.str;
		}

		private GenericArray<ReportImpl> get_sorted_reports () {
			var result = new GenericArray<ReportImpl>(_reports.length);
			for (int i = 0; i < _reports.length; i++) {
				result.add(_reports[i]);
			}
			result.sort_with_data((a, b) => {
				double ta = a.real_time;
				double tb = b.real_time;
				return ta < tb ? -1 : (ta == tb ? 0 : 1);
			});
			return result;
		}
	}

	private class ReportImpl : Object, Report {
		private string _label;
		private Func<Stopwatch> _job;
		private StopwatchImpl? _stopwatch;

		public ReportImpl (owned string label, owned Func<Stopwatch> job) {
			_label = (owned) label;
			_job = (owned) job;
		}

		public string label {
			get {
				return _label;
			}
		}

		public StopwatchImpl stopwatch {
			get {
				assert_nonnull(_stopwatch);
				return _stopwatch;
			}
		}

		public double monotonic_time {
			get {
				return _stopwatch.monotonic_time;
			}
		}

		public double real_time {
			get {
				return _stopwatch.real_time;
			}
		}

		public string note {
			get {
				return _stopwatch.note;
			}
		}

		public void measure () {
			_stopwatch = new StopwatchImpl();
			_stopwatch.start();
			_job(_stopwatch);
			if (!_stopwatch.is_stopped) _stopwatch.stop();
		}
	}

	private class StopwatchImpl : Object, Stopwatch {
		private double _monotonic_time;
		private double _real_time;
		private bool _started;
		private bool _stopped;
		private string _note = "";

		public double monotonic_time {
			get {
				assert(_stopped);
				return _monotonic_time;
			}
		}

		public double real_time {
			get {
				assert(_stopped);
				return _real_time;
			}
		}

		public bool is_stopped {
			get {
				return _stopped;
			}
		}

		public void start () {
			assert(!_stopped);
			_started = true;
			_monotonic_time = get_monotonic_time();
			_real_time = get_real_time();
		}

		public void stop () {
			assert(_started);
			assert(!_stopped);
			_stopped = true;
			_monotonic_time = (get_monotonic_time() - _monotonic_time) / 1000000.0;
			_real_time = (get_real_time() - _real_time) / 1000000.0;
		}

		public void notate (owned string note) {
			_note = (owned) note;
		}

		public string note {
			get {
				return _note;
			}
		}
	}

	private class ProgressHelper : Object {
		private const int PROGRESSBAR_WIDTH = 30;
		private const string PROGRESSBAR_OPEN = "[";
		private const string PROGRESSBAR_TAIL = "=";
		private const string PROGRESSBAR_HEAD = "#";
		private const string PROGRESSBAR_EMPTY = " ";
		private const string PROGRESSBAR_CLOSE = "]";

		private uint _total;
		private uint _current;

		public ProgressHelper (uint total) {
			_total = total;
		}

		public void progress () {
			if ( !Posix.isatty(Posix.stdout.fileno()) ) return;
			assert(_current < _total);
			double ratio = _total == 0 ? 1 : ((double) _current) / _total;
			string progressbar = gen_progressbar(ratio);
			double percent = ratio * 100;
			print("%s   %s %.1f%%", CLEAR_LINE, progressbar, percent);
			_current++;
		}

		private string gen_progressbar (double ratio) {
			int cur = (int) (PROGRESSBAR_WIDTH * ratio);
			StringBuilder buf = new StringBuilder();
			buf.append(PROGRESSBAR_OPEN);
			for (int i = 0, n = cur - 1; i < n; i++) {
				buf.append(PROGRESSBAR_TAIL);
			}
			buf.append(PROGRESSBAR_HEAD);
			for (int i = cur; i < PROGRESSBAR_WIDTH; i++) {
				buf.append(PROGRESSBAR_EMPTY);
			}
			buf.append(PROGRESSBAR_CLOSE);
			return buf.str;
		}
	}
}
