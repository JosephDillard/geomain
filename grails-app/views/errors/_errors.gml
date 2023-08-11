import org.springframework.validation.*

/**
 * Renders validation errors according to vnd.error: https://github.com/blongden/vnd.error
 */
model {
    Errors errors
}

xmlDeclaration()
response { status UNPROCESSABLE_ENTITY }

'errors' {
    Errors errorsObject = (Errors)this.errors
    def allErrors = errorsObject.allErrors
    int errorCount = allErrors.size()
    def resourcePath = g.link(resource:request.uri, absolute:false)
    def resourceLink = g.link(resource:request.uri, absolute:true)
    if(errorCount == 1) {
        def error = allErrors.iterator().next()
        'error' {
            message messageSource.getMessage(error, locale)
            path resourcePath
            _links {
                self {
                    href resourceLink
                }
            }
        }
    }
    else {
        total errorCount
        _embedded {
            errors(allErrors) { ObjectError error ->
                message messageSource.getMessage(error, locale)
                path resourcePath
                _links {
                    self {
                        href resourceLink
                    }
                }
            }
        }
    }
}
