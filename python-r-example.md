Python-R example
================

This is a simple example that uses both Python and R.

Load a data frame into R

``` r
library(reticulate)
set.seed(100)
my_data <- data.frame(
    id = 1:100,
    scores = runif(100,0,100)
)

head(my_data)
```

      id    scores
    1  1 30.776611
    2  2 25.767250
    3  3 55.232243
    4  4  5.638315
    5  5 46.854928
    6  6 48.377074

Look at it in Python

``` python

py_data = r.my_data

py_data.loc[0] = 1,72

print(py_data.head())
```

       id     scores
    0   1  72.000000
    1   2  25.767250
    2   3  55.232243
    3   4   5.638315
    4   5  46.854928

and back again to R

``` r
head(py$py_data)
```

      id    scores
    1  1 72.000000
    2  2 25.767250
    3  3 55.232243
    4  4  5.638315
    5  5 46.854928
    6  6 48.377074
