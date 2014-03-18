modifyList2 <- function (x, val) 
# changed the double square to single square brackets on assignment
# this has allows NULL values to overwrite and NOT delete items in x
{
    stopifnot(is.list(x), is.list(val))
    xnames <- names(x)
    for (v in names(val)) {
        x[v] <- if (v %in% xnames && is.list(x[[v]]) && is.list(val[[v]])) 
            modifyList(x[[v]], val[[v]])
        else val[v]
    }
    x
}
