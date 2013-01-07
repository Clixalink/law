createServiceFilters = require './createServiceFilters'

module.exports = (serviceName, serviceDef, argumentTypes) ->
  {generateDefaultValidations, generateValidationsFromParams} = createServiceFilters argumentTypes

  switch typeof serviceDef

    when 'function'
      return []

    when 'object'
      validations = []
      {required, optional, params} = serviceDef

      if required
        validations = validations.concat generateDefaultValidations serviceName, required, true

      if optional
        validations = validations.concat generateDefaultValidations serviceName, optional, false

      if params
        validations = validations.concat generateValidationsFromParams serviceName, params

      return validations

    else
      throw new Error "Service '#{serviceName}' is not an object or a function."
