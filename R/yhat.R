#' Wrapper over the predict function
#'
#' This function is just a wrapper over the predict function.
#' It sets different default parameters for models from different classes,
#' like for classification random Forest is forces the output to be probabilities not classes itself.
#'
#' @param X.model object - a model to be explained
#' @param newdata data.frame or matrix - observations for prediction
#' @param ... other parameters that will be passed to the predict function
#'
#' @return An numeric matrix of predictions
#'
#' @rdname yhat
#' @export
yhat <- function (X.model, newdata, ...)
  UseMethod("yhat")

#' @rdname yhat
#' @export
yhat.lm <- function(X.model, newdata, ...) {
  predict(X.model, newdata, ...)
}

#' @rdname yhat
#' @export
yhat.randomForest <- function(X.model, newdata, ...) {
  if (X.model$type == "classification") {
    pred <- predict(X.model, newdata, type = "prob", ...)
    if (ncol(pred) == 2) { # binary classification
      pred <- pred[,2]
    }
  } else {
    pred <- predict(X.model, newdata, ...)
  }
  pred
}

#' @rdname yhat
#' @export
yhat.svm <- function(X.model, newdata, ...) {
  if (X.model$type == 0) {
    pred <- attr(predict(X.model, newdata = newdata, probability = TRUE), "probabilities")
    if (ncol(pred) == 2) { # binary classification
      pred <- pred[,2]
    }
  } else {
    pred <- predict(X.model, newdata, ...)
  }
  pred
}

#' @rdname yhat
#' @export
yhat.glm <- function(X.model, newdata, ...) {
  predict(X.model, newdata, type = "response")
}


#' @rdname yhat
#' @export
yhat.ranger <- function(X.model, newdata, ...) {
  if (X.model$treetype == "Regression") {
    pred <- predict(X.model, newdata, ...)$predictions
  } else {
    # please note, that probability=TRUE should be set during training
    pred <- predict(X.model, newdata, ..., probability = TRUE)$predictions
    if (ncol(pred) == 2) { # binary classification
      pred <- pred[,2]
    }
  }
  pred
}

#' @rdname yhat
#' @export
yhat.default <- function(X.model, newdata, ...) {
  as.numeric(predict(X.model, newdata, ...))
}
