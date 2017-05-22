#_id:编号
#name: '',
#alias: '',
#auto_screen: [],
#auto_snapshot: '60',
#debug: '0',
#network: {},
#service: '',
#interval: '30',
#os: '',
#version: {},
#dsmversion: {},
#cpu: '',
#memory: '',
#disk: '',
#boot: '',
#snapshot: '',
#pixel: '',
#client_info: '',
#publish: [],
#commands: [],
#screen: 'off',
#online: false

#_room:会议室
#groups:分组

schema = new Schema
  name: {type: String, default :''}
  alias: {type: String, default :''}
  autoScreen: {type:Array, default :[]}
  autoSnapshot: {type:Number, default :60}
  debug: {type:Number, default :0}
  network: {type:Object, default :{}}
  service: {type:String, default :''}
  interval: {type:Number, default :30}
  os: {type:String, default :''}
  version: {type:Object, default :{}}
  mversion: {type:Object, default :{}}
  cpu: {type:String, default :''}
  memory: {type:String, default :''}
  disk: {type:String, default :''}
  boot: {type:String, default :''}
  snapshot: {type:String, default :''}
  pixel: {type:String, default :''}
#  clientInfo: {type:String, default :''}
#  publish: {type:Array, default :[]}
  commands: {type:Array, default :[]}
  lastLinkTime:{type:Date}
  isScreenOn: {type:String, default :'off'}
  online: {type:Boolean, default :false}

  room: {type:Schema.ObjectId, ref :'Room'}


module.exports = Box = mongoose.model('Box', schema, 'box')