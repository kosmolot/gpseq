# Benchmark

### 0.1.0-alpha+2

```sh
# CPU physical cores: 6
> CPU logical cores: 12
> Executor parallelism: 24
> sizeof(gint): 4
> sizeof(gpointer): 8
root)
   # chop(skip/limit) is a cheap operation on sequential execution,
   # and a very expensive operation on ordered parallel execution.
 - chop)                    monotonic        real
   chop:sequential:         0.327156s   0.327156s
   chop:parallel:           0.890078s   0.890079s   2.72x slower
   chop_ordered:parallel:   6.024235s   6.024235s   18.41x slower
   *total:                  7.241469s   7.241470s
   *avg:                    2.413823s   2.413823s
 - sum-int-collector)    monotonic        real
   sum_int:sequential:   2.209616s   2.209616s
   sum_int:parallel:     3.279789s   3.279789s   1.48x slower
   *total:               5.489405s   5.489405s
   *avg:                 2.744702s   2.744702s
 - to-list-collector)    monotonic        real
   to_list:parallel:     0.707828s   0.707828s
   to_list:sequential:   0.766985s   0.766985s   1.08x slower
   *total:               1.474813s   1.474813s
   *avg:                 0.737407s   0.737407s
 - complex-example)   monotonic        real
   parallel:          0.923097s   0.923097s
   sequential:        1.581997s   1.581997s   1.71x slower
   *total:            2.505094s   2.505094s
   *avg:              1.252547s   1.252547s
 - filter)              monotonic        real
   filter:parallel:     0.066071s   0.066071s
   filter:sequential:   0.433755s   0.433755s   6.56x slower
   *total:              0.499826s   0.499826s
   *avg:                0.249913s   0.249913s
 - find)                  monotonic        real
   find_any:parallel:     0.032764s   0.032764s
   find_first:parallel:   0.050130s   0.050130s   1.53x slower
   find_any:sequential:   0.597433s   0.597433s   18.23x slower
   *total:                0.680327s   0.680327s
   *avg:                  0.226776s   0.226776s
 - flat_map)              monotonic        real
   flat_map:sequential:   1.451127s   1.451127s
   flat_map:parallel:     2.978116s   2.978115s   2.05x slower
   *total:                4.429243s   4.429242s
   *avg:                  2.214621s   2.214621s
 - map)              monotonic        real
   map:parallel:     0.086996s   0.086996s
   map:sequential:   0.378656s   0.378656s   4.35x slower
   *total:           0.465652s   0.465652s
   *avg:             0.232826s   0.232826s
 - max)              monotonic        real
   max:parallel:     0.069252s   0.069252s
   max:sequential:   0.428050s   0.428049s   6.18x slower
   *total:           0.497302s   0.497301s
   *avg:             0.248651s   0.248650s
 - reduce)              monotonic        real
   reduce:parallel:     0.059383s   0.059382s
   reduce:sequential:   0.396022s   0.396021s   6.67x slower
   *total:              0.455405s   0.455403s
   *avg:                0.227703s   0.227702s
 - sort)                          monotonic        real
   Gpseq.parallel_sort:           0.723252s   0.723252s
   qsort_with_data:               2.577502s   2.577502s   3.56x slower
   GenericArray.sort_with_data:   2.669530s   2.669530s   3.69x slower
   ArrayList.sort:                3.198700s   3.198700s   4.42x slower
   *total:                        9.168984s   9.168984s
   *avg:                          2.292246s   2.292246s
```
