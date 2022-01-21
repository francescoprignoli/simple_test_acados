function ocp_model = model_setup(T)

[model, constraints, cost] = longitudinal_dyn();

ocp_model = acados_ocp_model();
ocp_model.set('name', model.name);
ocp_model.set('T', T); %horizon time length [s]

%% symbolics
ocp_model.set('sym_x', model.sym_x);
ocp_model.set('sym_u', model.sym_u);
ocp_model.set('sym_xdot', model.sym_xdot);
ocp_model.set('sym_p', model.sym_p);
% ocp_model.set('sym_z', model.z);

%% dynamics
ocp_model.set('dyn_type', 'explicit');
ocp_model.set('dyn_expr_f', model.expr_f_expl);

%% constraints
ocp_model.set('constr_expr_h',constraints.expr_h);
ocp_model.set('constr_lh',constraints.lh);
ocp_model.set('constr_uh',constraints.uh);
ocp_model.set('constr_expr_h_e',constraints.expr_h_e);
ocp_model.set('constr_lh_e',constraints.lh_e);
ocp_model.set('constr_uh_e',constraints.uh_e);

ocp_model.set('constr_Jbx', constraints.Jbx);
ocp_model.set('constr_lbx', constraints.lbx);
ocp_model.set('constr_ubx', constraints.ubx);
ocp_model.set('constr_Jbx_e', constraints.Jbx_e);
ocp_model.set('constr_lbx_e', constraints.lbx_e);
ocp_model.set('constr_ubx_e', constraints.ubx_e);

ocp_model.set('constr_Jbu', constraints.Jbu);
ocp_model.set('constr_lbu', constraints.lbu);
ocp_model.set('constr_ubu', constraints.ubu);

ocp_model.set('constr_x0', constraints.x0);

%% cost
ocp_model.set('cost_type', 'ext_cost');
ocp_model.set('cost_expr_ext_cost',cost.expr_ext_cost);
ocp_model.set('cost_type_e', 'ext_cost');
ocp_model.set('cost_expr_ext_cost_e', cost.expr_ext_cost_e);


end