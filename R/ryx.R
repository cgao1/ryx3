
#' Get a list of input variables y and x and a correlation table of y with all of x
#'
#'
#'@description
#' This \code{ryx} returns a list that can be used with other functions in this package.
#'
#' @param data The dataset that the variables are from
#' @param y The variable used to correlate with each of x
#' @param x The variable/variables to correlate with y
#'
#' @return A list of 1. y 2. x 3. correlation table of y correlated with each of x
#' @export
#'
#' @import ggplot2
#' @import stats
#'
#' @examples
#' \dontrun{
#' # Correlation of "medv" in the Boston dataset with every other variable in the dataset
#' library(MASS)
#' x <- ryx(Boston, y="medv")
#' x
#' }
ryx <- function(data, y, x){
  if(missing(x)){
    x <- names(data)[sapply(data, class)=="numeric"]
    x <- setdiff(x, y)
  }
  df <- data.frame()
  for (var in x){
    res <- cor.test(data[[y]], data[[var]])
    df_temp <- data.frame(variable = var,
                          r = res$estimate,
                          p = res$p.value)
    df <- rbind(df, df_temp)
    df <- df[order(-abs(df$r)),]
  }

  df$sigif <- ifelse(df$p < .001, "***",
                     ifelse(df$p < .01, "**",
                            ifelse(df$p < .05, "*", " ")))
  results <- list(y=y, x=x, df=df)
  class(results) <- "ryx"
  return(results)
}






#' Prints the correlation table
#'
#' @param x The list result from the ryx function
#' @param digits The number of digits we want to see in numbers within the correlation table
#'
#' @return A correlation table
#' @export
#'
#' @examples
#' \dontrun{
#' library(MASS)
#' x <- ryx(Boston, y="medv")
#' print.ryx(x, digits = 3)
#' }
print.ryx<- function(x, digits=3){
  if(!inherits(x,"ryx")){
    stop("Must be class 'ryx'")
  }
  x$df$r<-round(x$df$r,digits)
  x$df$p<-format.pval(x$df$p, digits)
  cat("Correlations of", x$y ,"with\n")
  print(x$df,row.names = FALSE)
}




#' Summary of the correlation results
#'
#' @param x The list result from the ryx function
#' @param digits The number of digits we want to see in the numbers within the summary
#'
#' @return A paragraph summarizing the results of the correlation
#' @export
#'
#' @examples
#' \dontrun{
#' library(MASS)
#' x <- ryx(Boston, y="medv")
#' summary.ryx(x, digits = 3)
#' }
summary.ryx<-function(x, digits=3){
  if(!inherits(x,"ryx")){
    stop("Must be class 'ryx'")
  }
  table1<-x$df
  y<-x$y
  median_corr<-median(abs(table1$r))
  numvarsig<-0
  for(i in table1$p){
    if(i<.05){
      numvarsig=numvarsig+1
    }
  }
  cat("Correlating", x$y ,"with", x$x, "\nThe median absolute correlation was", round(median_corr,digits=digits),
      "with a range from", round(min(table1$r), digits=digits) ,"to", round(max(table1$r),digits=digits), "\n",
      numvarsig,"out of", length(table1$r), "variables where significant at the p < 0.05 level.")
}





#' Create a Cleveland Dot Chart of the correlation
#'
#' @param x The list result from the ryx function
#'
#' @import ggplot2
#'
#' @return A Cleveland Dot Chart of the correlation
#' @export
#'
#' @examples
#' \dontrun{
#' library(MASS)
#' x <- ryx(Boston, y="medv")
#' plot.ryx(x)
#' }
plot.ryx<- function(x){
  if(!inherits(x,"ryx")){
    stop("Must be class 'ryx'")
  }
  Direction<-ifelse(x$df$r<0,"negative","positive")
  ggplot2::ggplot(x$df,
                  aes(x=abs(x$df$r),
                      y=stats::reorder(x$df$variable, abs(x$df$r)))) +
    geom_point(aes(color=Direction),
               size = 2) +
    scale_colour_manual(values = c(negative="red",positive="blue"))+
    geom_segment(aes(xend = 0,
                     yend= x$df$variable),
                 color = "grey") +
    labs (title = paste("Correlations with", x$y),
          x = "Correlation (absolute value)",
          y = "Variables") +
    theme_bw() +
    theme(panel.grid.major.y = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_line(colour = "grey", linetype="dashed"))+
    scale_x_continuous(limits = c(0,1),breaks = seq(0,1, by=0.1))
}

