# Benchmark

### 0.1.0-alpha+2

```sh
# CPU physical cores: 6
> CPU logical cores: 12
> Executor parallelism: 24
> sizeof(gint): 4
> sizeof(gpointer): 8
root)
 - chop)                    monotonic        real
   chop:sequential:         0.310896s   0.310895s
   chop:parallel:           0.891581s   0.891582s   2.87x slower
   chop_ordered:parallel:   6.017017s   6.017016s   19.35x slower
   *total:                  7.219494s   7.219493s
   *avg:                    2.406498s   2.406498s
 - sum-int-collector)    monotonic        real
   sum_int:sequential:   2.394352s   2.394351s
   sum_int:parallel:     3.270564s   3.270564s   1.37x slower
   *total:               5.664916s   5.664915s
   *avg:                 2.832458s   2.832457s
 - to-list-collector)    monotonic        real
   to_list:parallel:     0.666823s   0.666823s
   to_list:sequential:   0.762276s   0.762276s   1.14x slower
   *total:               1.429099s   1.429099s
   *avg:                 0.714549s   0.714549s
 - complex-example)   monotonic        real
   parallel:          0.071369s   0.071369s
   sequential:        0.451558s   0.451558s   6.33x slower
   *total:            0.522927s   0.522927s
   *avg:              0.261464s   0.261464s
 - filter)              monotonic        real
   filter:parallel:     0.058522s   0.058522s
   filter:sequential:   0.426998s   0.426999s   7.30x slower
   *total:              0.485520s   0.485521s
   *avg:                0.242760s   0.242761s
 - find)                  monotonic        real
   find_any:parallel:     0.012351s   0.012350s
   find_first:parallel:   0.088249s   0.088249s   7.15x slower
   find_any:sequential:   0.304904s   0.304905s   24.69x slower
   *total:                0.405504s   0.405504s
   *avg:                  0.135168s   0.135168s
 - flat_map)              monotonic        real
   flat_map:sequential:   1.390953s   1.390953s
   flat_map:parallel:     2.998777s   2.998777s   2.16x slower
   *total:                4.389730s   4.389730s
   *avg:                  2.194865s   2.194865s
 - map)              monotonic        real
   map:parallel:     0.085941s   0.085941s
   map:sequential:   0.432336s   0.432336s   5.03x slower
   *total:           0.518277s   0.518277s
   *avg:             0.259138s   0.259138s
 - max)              monotonic        real
   max:parallel:     0.064604s   0.064604s
   max:sequential:   0.418837s   0.418837s   6.48x slower
   *total:           0.483441s   0.483441s
   *avg:             0.241721s   0.241721s
 - reduce)              monotonic        real
   reduce:parallel:     0.059855s   0.059856s
   reduce:sequential:   0.364041s   0.364041s   6.08x slower
   *total:              0.423896s   0.423897s
   *avg:                0.211948s   0.211949s
 - sort)                          monotonic        real
   Gpseq.parallel_sort:           0.699067s   0.699067s
   GenericArray.sort_with_data:   2.533471s   2.533472s   3.62x slower
   qsort_with_data:               2.547208s   2.547208s   3.64x slower
   ArrayList.sort:                3.179009s   3.179009s   4.55x slower
   *total:                        8.958755s   8.958756s
   *avg:                          2.239689s   2.239689s
```
