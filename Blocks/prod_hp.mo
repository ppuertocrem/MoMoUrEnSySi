within MoMoUrEnSySi.Blocks;

model prod_hp "Hysteresis controlled smart grid ready heat pump with thermal buffer"
	extends MoMoUrEnSySi.Partial.PFPTM_io_pelec(
		redeclare Modelica.Blocks.Interfaces.IntegerInput io);

	// Nodes ++++++++++++++++++++++++++++++++++++++++++++++++++
	replaceable MoMoUrEnSySi.Base.pid_pump pump_srce;
	replaceable MoMoUrEnSySi.Base.pid_pump pump_sink;
	replaceable MoMoUrEnSySi.Base.buffer buffer;
	replaceable MoMoUrEnSySi.Base.smart_grid_ready_ctrl ctrl;
	replaceable MoMoUrEnSySi.Base.heat_pump hp;

equation

	ctrl.io_smart = io

	connect(pump_srce.flowPort_b1, hp.flowPort_a1);
	connect(hp.flowPort_b1, pump_srce.flowPort_a2);

	connect(hp.flowPort_b2, pump_sink.flowPort_a1);
	connect(pump_sink.flowPort_b2, hp.flowPort_a2);

	connect(pump_sink.flowPort_b1, buffer.flowPort_a1);
	connect(buffer.flowPort_b1, pump_sink.flowPort_a2);

	connect(ctrl.io, hp.io);
	connect(ctrl.io, pump_srce.io);
	connect(ctrl.io, pump_sink.io);

	connect(buffer.t_top, ctrl.t_top);

	power = hp.power + pump_srce.power + pump_sink.power;

end prod_hp;