# 本文件功能为初始化变量



# RIOH驾驶模拟器数据重新命名
RionSimDataName4<- c("Time",                     # 锘縠lapsed.time.s.,       # 场景时间，s
                    "Time_carsim",              # CarSim.TruckSim.time.s.,  # CarSim/TruckSim时间，s
                    "Ab_time",                  # absolute.time,            # 主机电脑时间，hh:mm:ss:ms
                    "Car_type",                 # car.type,                 # 车型
                    "Car_name",                 # name,                     # 车辆名称
                    "ID",                       # ID,
                    "Position_x",               # position.x.,              # 世界坐标系x坐标
                    "Position_y",               # position.y.,              # 世界坐标系y坐标
                    "Position_z",               # position.z.,              # 世界坐标系z坐标
                    "Direction_x",              # direction.x.,
                    "Direction_y",              # direction.y.,
                    "Direction_z",              # direction.z.,
                    "Yaw",                      # yaw.rad.,                 # 偏航角，rad
                    "Pitch",                    # pitch.rad.,               # 纵摇角，rad
                    "Roll",                     # roll.rad.,                # 翻滚角，rad
                    "Intersection",             # in.intersection,          # 是否为交叉口
                    "Rd",                       # road,                     # 道路名称
                    "Dis",                      # distance.from.road.start, # 距离道路起点位置，m
                    "Rd_width",                 # carriage.way.width,       # 模拟车所在道路宽度，m
                    "Left_bd",                  # left.border.distance,     # 模拟车距离道路左侧边缘位置，m
                    "Right_bd",                 # right.border.distance,    # 模拟车距离道路右侧边缘位置，m
                    "Tral_dis",                 # traveled.distance,        # 模拟车行驶距离，m
                    "Lane_dir",                 # lane.direction.rad.,      # 道路方向，rad
                    "Lane_num",                 # lane.number,              # 模拟车所在车道号
                    "Lane_width",               # lane.width,               # 模拟车所在车道宽度，m
                    "Lane_offset",              # lane.offset,              # 模拟车偏离所在车道中心线距离，m
                    "Rd_offset",                # road.offset,              # 模拟车偏离所在道路中心线距离，m
                    "Lateral_slope",            # road.lateral.slope.rad.,  # 道路横坡，rad
                    "Longitudinal_slope",       # road.longitudinal.slope,  # 道路纵坡
                    "Gear",                     # gear,                     # 模拟车行驶档位
                    "Light",                    # light.status,             # 车灯状态
                    "RPM",                      # rpm,                      # 模拟车转速
                    "Speed",                    # speed.m.s.,               # 车速，m/s
                    "Speed_x",                  # speed.vector_x.m.s.,      # 车速在x方向分量，m/s
                    "Speed_y",                  # speed.vector_y.m.s.,      # 车速在y方向分量，m/s
                    "Speed_z",                  # speed.vector_z.m.s.,      # 车速在z方向分量，m/s
                    "Acc_sway",                 # local.acceleration_sway.m.s.2.,            # 模拟车横向加速度，m/s^2
                    "Acc_heave",                # local.acceleration_heave.m.s.2.,           # 模拟车垂直加速度，m/s^2
                    "Acc_surge",                # local.acceleration_surge.m.s.2.,           # 模拟车纵向加速度，m/s^2
                    "Yaw_speed",                # rotation.speed_yaw.rad.s.,                 # 模拟车yaw角速度，rad/s
                    "Pitch_speed",              # rotation.speed_pitch.rad.s.,               # 模拟车pitch角速度，rad/s
                    "Roll_speed",               # rotation.speed_roll.rad.s.,                # 模拟车roll角速度，rad/s
                    "Acc_yaw",                  # rotation.acceleration_yaw.rad.s.2.,        # 模拟车yaw角加速度，rad/s^2
                    "Acc_pitch",                # rotation.acceleration_pitch.rad.s.2.,      # 模拟车pitch角加速度，rad/s^2
                    "Acc_roll",                 # rotation.acceleration_roll.rad.s.2.,       # 模拟车roll角加速度，rad/s^2
                    "Steering",                 # steering,                 # 方向盘转角
                    "Acc_pedal",                # acceleration.pedal,       # 加速踏板踩踏深度
                    "Brake_pedal",              # brake.pedal,              # 制动踏板踩踏深度
                    "Clutch_pedal",             # clutch.pedal,             # 离合踏板踩踏深度
                    "Hand_brake",               # hand.brake,               # 手刹状态
                    "Key",                      # ignition.key,             # 钥匙开关是否激活
                    "Gear_level",               # gear.lever,               # 模拟车行驶档位
                    "Wiper",                    # wiper,                    # 雨刷状态
                    "Horn",                     # horn,                     # 喇叭状态
                    "Car_weight",               # car.weight.kg.,           # 模拟车质量，kg
                    "Car_wheelbase",            # car.wheelbase,            # 模拟车轴距，m
                    "Car_width",                # car.width,                # 模拟车宽度，m
                    "Car_length",               # car.length,               # 模拟车长度，m
                    "Car_height",               # car.height,               # 模拟车高度，m
                    "front_left_wheel_x",
                    "front_left_wheel_y",
                    "front_right_wheel_x",
                    "front_right_wheel_y",
                    "rear_left_wheel_x",
                    "rear_left_wheel_y",
                    "rear_right_wheel_x",
                    "rear_right_wheel_y",
                    "TTC_front",                # front.vehicle.TTC.s.,       # 前车TTC，车速小于前车，输出n/a
                    "Dis_front",                # front.vehicle.distance.m.,  # 前车距离
                    "TTC_rear",                 # rear.vehicle.TTC.s.,        # 后车TTC
                    "Dis_rear",                 # rear.vehicle.distance.m.,   # 后车距离
                    "Speed_rear",               # rear.vehicle.speed.m.s.,    # 后车速度，m/s
                    "road_bumps",
                    "Scen"                      # scenario.name               # 场景名称
                    )

# 北方工业大学NCUT驾驶模拟器数据重新命名
RionSimDataName10 <- c("simTime",                  # Time
                     "logType",                  # Type
                     "carModel",                 # Model
                     "logID",                    # ID
                     "logDescription",           # description
                     "positionX",                # position.X
                     "positionY",                # position.Y
                     "positionZ",                # position.Z
                     "yawAngle",                 # yawAngle
                     "pitchAngle",               # pitchAngle
                     "rollAngle",                # rollAngle
                     "directionX",               # direction.X
                     "directionY",               # direction.Y
                     "directionZ",               # direction.Z
                     "bodyPitchAngle",           # bodyPitchAngle
                     "bodyRollAngle",            # bodyRollAngle
                     "RPM",                      # RPM
                     "gearNumber",               # gearNumber
                     "speedXMS",                 # speedVectInMetresPerSecond.X
                     "speedYMS",                 # speedVectInMetresPerSecond.Y
                     "speedZMS",                 # speedVectInMetresPerSecond.Z
                     "speedKH",                  # speedInKmPerHour
                     "speedMS",                  # speedInMetresPerSecond
                     "accXMS2",                  # localAccelInMetresPerSecond2.X
                     "accYMS2",                  # localAccelInMetresPerSecond2.Y
                     "accZMS2",                  # localAccelInMetresPerSecond2.Z
                     "bodyRotSpeedYawRS",        # bodyRotSpeedInRadsPerSecond.Yaw
                     "bodyRotSpeedPitchRS",      # bodyRotSpeedInRadsPerSecond.Pitch
                     "bodyRotSpeedRollRS",       # bodyRotSpeedInRadsPerSecond.Roll
                     "bodyRotAccYawRS2",         # bodyRotAccelInRadsPerSecond.Yaw
                     "bodyRotAccPitchRS2",       # bodyRotAccelInRadsPerSecond.Pitch
                     "bodyRotAccRollRS2",        # bodyRotAccelInRadsPerSecond.Roll
                     "rotSpeedYawRS",            # rotSpeedInRadsPerSecond.Yaw
                     "rotSpeedPitchRS",          # rotSpeedInRadsPerSecond.Pitch
                     "rotSpeedRollRS",           # rotSpeedInRadsPerSecond.Roll
                     "rotAccYawRS2",             # rotAccelInRadsPerSecond.Yaw
                     "rotAccPitchRS2",           # rotAccelInRadsPerSecond.Pitch
                     "rotAccRollRS2",            # rotAccelInRadsPerSecond.Roll
                     "disTravelled",             # distanceTravelled
                     "steeringValue",            # steering
                     "steeringVelocity",         # steeringVelocity
                     "turningCurvature",         # turningCurvature
                     "gasPedal",                 # throttle
                     "brakePedal",               # brake
                     "lightState",               # lightState
                     "automaticControl",         # automaticControl
                     "dragForce",                # dragForce
                     "carMass",                  # mass
                     "carWheelbase",             # wheelBase
                     "centerofGravityHeight",    # centerOfGravityHeight
                     "centerofGravityPosition",  # centerOfGravityPosition
                     "rollAxisHeight",           # rollAxisHeight
                     "trailerState",             # trailer
                     "trailerAngle",             # trailerAngle
                     "trailerPitchAngle",        # trailerPitchAngle
                     "trailerWheelbase",         # trailerWheelbase
                     "isInIntersection",         # inIntersection
                     "roadName",                 # road
                     "disFromRoadStart",         # distanceAlongRoad
                     "disToLeftBorder",          # distanceToLeftBorder
                     "disToRightBorder",         # distanceToRightBorder
                     "carriagewayWidth",         # carriagewayWidth
                     "roadOffset",               # offsetFromRoadCenter
                     "laneOffset",               # offsetFromLaneCenter
                     "longitudinalSlope",        # roadLongitudinalSlope
                     "lateralSlope",             # roadLateralSlope
                     "laneNumber",               # laneNumber
                     "laneWidth",                # laneWidth
                     "laneDirectionX",           # laneDirection.X
                     "laneDirectionY",           # laneDirection.Y
                     "laneDirectionZ",           # laneDirection.Z
                     "laneCurvature",            # laneCurvature
                     "isDrivingForward",         # drivingForwards
                     "speedLimit",               # speedLimit
                     "isSpeedOver",              # speedOver
                     "leftLaneOverlap",          # leftLaneOverLap
                     "rightLaneOverlap",         # rightLaneOverLap
                     "collisionWithUser",        # collisionWithUser
                     "pedestrianNumber",         # pedestriansNumber
                     "roadSurface",              # surface
                     "averageFlux",              # averageFlux
                     "X")                        #X

# RIOH ver12.0 模拟器重命名
RionSimDataName12<-c("Time",                            # 场景时间，s
                     "Time_Stmp",                       # 主机电脑时间，hh:mm:ss:ms
                     "Type",                            # log文件的输出对象，uv：自车/fv:前车/so:周边对象/oo:其他对象
                     "Car_name",                        # 车辆名称              
                     "ID",
                     "ID_custom",
                     "description",
                     "Position_x",                      # 世界坐标系x坐标,向东为正
                     "Position_y",                      # 世界坐标系y坐标,向上为正
                     "Position_z",                      # 世界坐标系z坐标,向北为正
                     "Yaw",                             # 偏航角，rad
                     "Pitch",                           # 纵摇角，rad
                     "Roll",                            # 翻滚角，rad
                     "Direction_x",                     # 车辆行驶方向X分量
                     "Direction_y",                     # 车辆行驶方向y分量
                     "Direction_z",                     # 车辆行驶方向z分量
                     "Body_pitch",                      # 车体的纵摇角，rad
                     "Body_roll",                       # 车体的翻滚角，rad
                     "RPM",                             # 模拟车转速
                     "Gear",                            # 模拟车行驶档位
                     "Speed_x",                         # 车速在x方向分量，m/s
                     "Speed_y",                         # 车速在y方向分量，m/s 
                     "Speed_z",                         # 车速在z方向分量，m/s
                     "Speed",                           # 车速，km/h
                     "Speed_m/s",                       # 车速，m/s
                     "Acc_sway",                        # 模拟车横向加速度，m/s^2
                     "Acc_heave",                       # 模拟车垂直加速度，m/s^2
                     "Acc_surge",                       # 模拟车纵向加速度，m/s^2
                     "Body_yaw_speed",                  # 车体的yaw角速度，rad/s
                     "Body_pitch_speed",                # 车体的pitch角速度，rad/s
                     "Body_roll_speed",                 # 车体的roll角速度，rad/s
                     "Body_acc_yaw",                    # 车体的yaw角加速度，rad/s^2
                     "Body_acc_pitch",                  # 车体的Pitch角加速度，rad/s^2
                     "Body_acc_roll",                   # 车体的roll角加速度，rad/s^2
                     "Yaw_speed",                       # 模拟车yaw角速度，rad/s
                     "Pitch_speed",                     # 模拟车pitch角速度，rad/s
                     "Roll_speed",                      # 模拟车roll角速度，rad/s
                     "Acc_yaw",                         # 模拟车yaw角加速度，rad/s^2
                     "Acc_pitch",                       # 模拟车Pitch角加速度，rad/s^2
                     "Acc_roll",                        # 模拟车roll角加速度，rad/s^2
                     "Tral_dis",                        # 模拟车行驶距离，m
                     "Steering",                        # 方向盘转角
                     "App_steering",                    # 方向盘相对转角
                     "Steering_Vel",                    # 方向盘的旋转率，1/s
                     "Turning_curvature",               # 车辆当前转动曲率,1/m
                     "Acc_pedal",                       # 加速踏板踩踏深度
                     "Pedal_torque",                    # 踏板扭矩,N・m
                     "App_acc",                         # 加速踏板相对踩踏深度
                     "Brake_pedal",                     # 制动踏板踩踏深度
                     "App_brake",                       # 制动踏板相对踩踏深度
                     "Light",                           # 车灯状态
                     "Auto_control",                    # 是否自动驾驶
                     "Drag_force",                      # 空气阻力,N
                     "Car_weight",                      # 模拟车质量，kg
                     "Car_wheelbase",                   # 模拟车轴距，m
                     "CG_height",                       # 车辆重心高度，m
                     "CG_position",                     # 车辆重心位置，m
                     "Roll_axis_height",                # 车辆roll轴高度，m
                     "Trailer",                         # 拖车模型
                     "Trailer_yaw",                     # 拖车偏航角，rad
                     "Trailer_Pitch",                   # 拖车纵摇角，rad
                     "Trailer_Wheelbase",               # 拖车轴距，m
                     "Intersection",                    # 是否为交叉口
                     "Rd",                              # 道路名称
                     "Dis",                             # 距离道路起点位置，m
                     "Latest_rd",                       # 越野或进入交叉口前车辆行驶的道路名称
                     "Dis_latest_rd",                   # 距离越野或交叉口前车辆行驶道路的位置，m
                     "Left_bd",                         # 模拟车距离道路左侧边缘位置，m
                     "Right_bd",                        # 模拟车距离道路右侧边缘位置，m
                     "Rd_width",                        # 模拟车所在道路宽度，m
                     "Rd_offset",                       # 模拟车偏离所在道路中心线距离，m
                     "Lane_offset",                     # 模拟车偏离所在车道中心线距离，m
                     "Longitudinal_slope",              # 道路纵坡
                     "Lateral_slope",                   # 道路横坡
                     "Lane_num",                        # 模拟车所在车道号
                     "Lane_width",                      # 模拟车所在车道宽度，m
                     "Lane_dir_x",                      # 车道方向x轴分量
                     "Lane_dir_y",                      # 车道方向y轴分量
                     "Lane_dir_z",                      # 车道方向z轴分量
                     "Lane_curvature",                  # 车辆所在车道的曲率，1/m
                     "Driving_forwards",                # 上行方向：TRUE，下行方向：FALSE
                     "Speed_limit",                     # 当前车道限速，km/h
                     "Speed_Over",                      # 是否超速
                     "OverLap_left",                    # 车辆超出车道左侧的宽度与车辆宽度的比率
                     "OverLap_right",                   # 车辆超出车道右侧的宽度与车辆宽度的比率
                     "Collision",
                     "Pedestrian_num", 
                     "Surface",
                     "Avg_flux"
                     )
