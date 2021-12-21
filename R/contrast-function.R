# Source: https://github.com/trobinj/trtools/blob/master/R/contrast.R
# see above for documentation
contrast.glm <- function(model, a, b, u, v, df, tf, cnames, level = 0.95, fcov = vcov, delta = FALSE, ...) {
  if (all(missing(a), missing(b), missing(u), missing(v))) {
    stop("no contrast(s) specified")
  }
  eta <- function(theta, model, data) {
    model$coefficients <- theta
    predict(model, as.data.frame(data))
  }
  if (!missing(a)) {
    ma <- numDeriv::jacobian(eta, coef(model), model = model, data = a)
    pa <- predict(model, as.data.frame(a))
  }
  else {
    ma <- 0
    pa <- 0
  }
  if (!missing(b)) {
    mb <- numDeriv::jacobian(eta, coef(model), model = model, data = b)
    pb <- predict(model, as.data.frame(b))
  }
  else {
    mb <- 0
    pb <- 0
  }
  if (!missing(u)) {
    mu <- numDeriv::jacobian(eta, coef(model), model = model, data = u)
    pu <- predict(model, as.data.frame(u))
  }
  else {
    mu <- 0
    pu <- 0
  }
  if (!missing(v)) {
    mv <- numDeriv::jacobian(eta, coef(model), model = model, data = v)
    pv <- predict(model, as.data.frame(v))
  }
  else {
    mv <- 0
    pv <- 0
  }
  rowmax <- max(unlist(lapply(list(ma, mb, mu, mv), function(x) ifelse(is.matrix(x), nrow(x), 0))))
  if (is.matrix(ma) && nrow(ma) == 1) {
    ma <- ma[rep(1, rowmax),]
    pa <- pa[rep(1, rowmax)]
  }
  if (is.matrix(mb) && nrow(mb) == 1) {
    mb <- mb[rep(1, rowmax),]
    pb <- pb[rep(1, rowmax)]
  }
  if (is.matrix(mu) && nrow(mu) == 1) {
    mu <- mu[rep(1, rowmax),]
    pu <- pu[rep(1, rowmax)]
  }
  if (is.matrix(mv) && nrow(mv) == 1) {
    mv <- mv[rep(1, rowmax),]
    pv <- pv[rep(1, rowmax)]
  }
  mm <- as.matrix(ma - mb - mu + mv)
  if (ncol(mm) == 1) {
    mm <- t(mm)
  }
  
  pe <- pa - pb - pu + pv
  
  if (missing(df)) {
    if (family(model)[1] %in% c("binomial","poisson")) {
      df <- Inf
    }
    else {
      df <- summary(model)$df[2]
    }
  }
  
  if (!missing(tf)) {
    gr <- numDeriv::jacobian(tf, pe) 
    if (any(diag(nrow(gr)) != (gr != 0) %*% t(gr != 0))) {
      delta <- TRUE
    }
  }
  if (delta & !missing(tf)) {
    se <- sqrt(diag(gr %*% mm %*% fcov(model) %*% t(mm) %*% t(gr)))
    pe <- tf(pe)
  } else {
    se <- sqrt(diag(mm %*% fcov(model) %*% t(mm)))
  }
  
  lw <- pe - qt(level + (1 - level)/2, df) * se
  up <- pe + qt(level + (1 - level)/2, df) * se
  
  ts <- pe/se
  pv <- 2*pt(-abs(ts), df)
  
  if (missing(tf) | delta) {
    out <- cbind(pe, se, lw, up, ts, df, pv)
    colnames(out) <- c("estimate", "se", "lower", "upper", "tvalue", "df", "pvalue")
  } else {
    out <- cbind(tf(pe), tf(lw), tf(up))
    for (i in 1:nrow(out)) {
      if (out[i,2] > out[i,3]) {
        out[i,2:3] <- out[i,3:2] 
      }
    }
    colnames(out) <- c("estimate", "lower", "upper")
  }
  if (missing(cnames)) {
    rownames(out) <- rep("", nrow(out))
  }
  else {
    rownames(out) <- as.character(cnames)
  }
  return(out)
}
