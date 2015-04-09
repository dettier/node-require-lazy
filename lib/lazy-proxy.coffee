Reflect = require 'harmony-reflect'
Handlers = require('proxy-handlers')
VirtualHandler = Handlers.VirtualHandler

LazyProxy = (thunk) ->
  @thunk = thunk
  @val = undefined

LazyProxy.prototype = Object.create(VirtualHandler.prototype)
LazyProxy.prototype.force = () ->
  if @thunk != null
    @val = @thunk.call(undefined)
    @thunk = null

methods = [
  'getPrototypeOf'
  'setPrototypeOf'
  'isExtensible'
  'preventExtensions'
  'getOwnPropertyDescriptor'
  'defineProperty'
  'has'
  'get'
  'set'
  'deleteProperty'
  'enumerate'
  'ownKeys'
  'apply'
  'construct'
]

for v in methods
  do (v) ->
    LazyProxy.prototype[v] = (target, args...) ->
      @force()
      Reflect[v] @val, args...

module.exports = (thunk) ->
  new Proxy {}, new LazyProxy(thunk)