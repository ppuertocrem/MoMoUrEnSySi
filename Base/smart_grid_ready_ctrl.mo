within MoMoUrEnSySi.Base;

model smart_grid_ready_ctrl "smart grid ready hysteresis ctrl"

	// Input
	Modelica.Blocks.Interfaces.IntergerInput io_smart
	Modelica.Blocks.Interfaces.RealInput t_set
	Modelica.Blocks.Interfaces.RealInput t_top

	// Output
	Modelica.Blocks.Interfaces.BooleanOutput io

	// Nodes
	Modelica.Blocks.Logical.GreaterThreshold positif(threshold=0);
	Modelica.Blocks.Logical.And finalAnd;
	Momourensysi.Base.hysteresis hysteresis;
	Modelica.Blocks.Logical.Add add(k1=5);

equation


	positif.u = io_smart
	
	add.u1 = io_smart
	add.u2 = t_set
	
	hysteresis.uHigh = add.y

	io = finalAnd.y


end smart_grid_ready_ctrl;