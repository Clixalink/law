applyDependencies = (services, resolver) ->
  wrappedServices = {}
  for serviceName, serviceDef of services
    dependencies = {}
    
    # we will create keys for any declared dependency types
    # and have them map to resolved dependencies
    for dependencyType of serviceDef.dependencies
      # initialize sub-object for this dependencyType
      dependencies[dependencyType] = {}
      
      # populate it with resolved service references
      for dependencyName in serviceDef.dependencies[dependencyType]
        dependencies[dependencyType][dependencyName] = resolver[dependencyType] dependencyName
    
    makeWrapper = (serviceName, serviceDef, dependencies) ->
      wrapper = (args, done) ->
        serviceDef args, done, dependencies
      for key in Object.keys serviceDef
        wrapper[key] = serviceDef[key]
      wrapper.dependencies = dependencies
      return wrapper

    wrapper = makeWrapper serviceName, serviceDef, dependencies
    # wrapper = (args, done) -> services[serviceName] args, done, dependencies
    wrappedServices[serviceName] = wrapper
  return wrappedServices

module.exports = applyDependencies