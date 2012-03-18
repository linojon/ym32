// The validator variable is a JSON Object
// The selector variable is a jQuery Object
clientSideValidations.validators.local['proper_name'] = function(element, options) {
  // not blank and contains only valid chars (alpha, apostrophe, hyphen, blank)
  if ($.trim(element.val()).length!=0 && !/^[a-zA-Z\'\-\x20]+$/.test(element.val())) {
    // When the value fails to pass validation you need to return the error message.
    // It can be derived from validator.message
    return options.message;
  }
}
