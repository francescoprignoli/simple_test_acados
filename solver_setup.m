function ocp_opts = solver_setup(N,T)
%% Solver parameters
compile_interface = 'auto';
codgen_model = 'true';
nlp_solver = 'sqp_rti'; % sqp, sqp_rti
qp_solver = 'partial_condensing_hpipm'; % full_condensing_hpipm, partial_condensing_hpipm, full_condensing_qpoases
nlp_solver_exact_hessian = 'false'; % false=gauss_newton, true=exact    
qp_solver_cond_N = 5; % for partial condensing
regularize_method = 'no_regularize';
%regularize_method = 'project';
%regularize_method = 'mirror';
%regularize_method = 'convexify';
% integrator typs
sim_method = 'erk'; % erk, irk, irk_gnsf
tol = 1e-7;

%% acados ocp set opts
ocp_opts = acados_ocp_opts();
ocp_opts.set('compile_interface', compile_interface);
ocp_opts.set('codgen_model', codgen_model);
ocp_opts.set('param_scheme_N', N);
ocp_opts.set('shooting_nodes', 0:T/N:T);
ocp_opts.set('nlp_solver', nlp_solver);
ocp_opts.set('nlp_solver_exact_hessian', nlp_solver_exact_hessian); 
% ocp_opts.set('nlp_solver_max_iter',1);

ocp_opts.set('sim_method', sim_method);
ocp_opts.set('sim_method_num_stages', 4);
ocp_opts.set('sim_method_num_steps', 3);
ocp_opts.set('qp_solver', qp_solver);
ocp_opts.set('regularize_method', regularize_method);
if (strcmp(qp_solver, 'partial_condensing_hpipm'))
	ocp_opts.set('qp_solver_cond_N', qp_solver_cond_N);
% 	ocp_opts.set('qp_solver_cond_ric_alg', 1);
% 	ocp_opts.set('qp_solver_ric_alg', 1);
	ocp_opts.set('qp_solver_warm_start', 0);
    ocp_opts.set('qp_solver_iter_max',100);
end
% ocp_opts.set('nlp_solver_tol_stat', tol);
% ocp_opts.set('nlp_solver_tol_eq', tol);
% ocp_opts.set('nlp_solver_tol_ineq', tol);
% ocp_opts.set('nlp_solver_tol_comp', tol);
ocp_opts.set('print_level', 0);
% ... see ocp_opts.opts_struct to see what other fields can be set
ocp_opts.set('output_dir',[pwd '/build']);

% ocp_opts.set('parameter_values', [200, 36/3.6]);