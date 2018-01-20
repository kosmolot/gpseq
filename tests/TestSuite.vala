/* TestSuite.vala
 *
 * This file has been based on testcase.vala of libgee.
 * see the below libgee license information.
 */

/* testcase.vala
 *
 * Copyright (C) 2009 Julien Peeters
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Julien Peeters <contact@julienpeeters.fr>
 */

namespace Gpseq {
	public abstract class TestSuite : Object {
		private GLib.TestSuite _suite;
		private Adaptor[] _adaptors = {};

		public TestSuite (string name) {
			_suite = new GLib.TestSuite(name);
		}

		public void register () {
			GLib.TestSuite.get_root().add_suite(_suite);
		}

		public void add_test (string name, owned TestFunc test) {
			var adaptor = new Adaptor (name, (owned) test, this);
			_adaptors += adaptor;
			var test_case = new GLib.TestCase(adaptor.name, adaptor.set_up, adaptor.run, adaptor.tear_down);
			_suite.add(test_case);
		}

		public virtual void set_up() {
		}

		public virtual void tear_down() {
		}

		private class Adaptor {
			[CCode (notify = false)]
			public string name { get; private set; }
			private TestFunc _test;
			private TestSuite _suite;

			public Adaptor (string name, owned TestFunc test, TestSuite suite) {
				_name = name;
				_test = (owned) test;
				_suite = suite;
			}

			public void set_up (void* fixture) {
				_suite.set_up();
			}

			public void run (void* fixture) {
				_test();
			}

			public void tear_down (void* fixture) {
				_suite.tear_down();
			}
		}

		public delegate void TestFunc ();
	}
}
