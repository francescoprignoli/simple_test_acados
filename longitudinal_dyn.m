function [model, constraints, cost] = longitudinal_dyn()
import casadi.*

%% system dimensions
nx = 3;
nu = 1;

%% system parameters
v_min = 0; % [m/s]
v_max = 50; % [m/s]
a_min = -5; % [m/s^2]
a_max = 3; % [m/s^2]
j_min = -4; % [m/s^3]
j_max = 4; % [m/s^3]
s_max = MX.sym('s_max'); % traveled space upper bound for collision avoidance [m]
v_ref = MX.sym('v_ref'); % target speed [m/s]

%% named symbolic variables
s = MX.sym('s');         % traveled space on the reference path [m]
v = MX.sym('v');         % longitudinal speed [m/s]
a = MX.sym('a');         % acceleration [m/s^2]
j = MX.sym('j');         % jerk [m/s^3]

%% (unnamed) symbolic variables
sym_x = vertcat(s, v, a);
sym_xdot = MX.sym('xdot', nx, 1); 
sym_u = j;
sym_p = vertcat(s_max, v_ref);      % parameters adjustable at run time
% sym_z = [];       % algebraic states

%% dynamics
expr_f_expl = vertcat(v, ...
                      a, ...
                      j);
expr_f_impl = expr_f_expl - sym_xdot;

%% constraints
x0 = zeros(nx,1);

% STATE CONSTRAINTS (stage and terminal)
Jbx = zeros(2,nx);
Jbx(1,2) = 1;
Jbx(2,3) = 1;
lbx = [v_min,a_min];
ubx = [v_max,a_max];
% Jsbx = zeros(2,nx);       %map slack variables

Jbx_e = zeros(2,nx);
Jbx_e(1,2) = 1;
Jbx_e(2,3) = 1;
lbx_e = [v_min,a_min];
ubx_e = [v_max,a_max];
% Jsbx_e = zeros(2,nx);       %map slack variables


% CONTROL CONSTRAINTS (stage only)
Jbu = eye(nu);
lbu = j_min;
ubu = j_max;
% Jsbu = zeros(nu,nu);       %map slack variables


% CUSTOM (NONLINEAR) CONSTRAINTS h(x,u,p) (stage and terminal)
expr_h = s-s_max;
lh = -1e3; %[m]
uh = 0; %[m]
% Jsh = zeros(1,1);       %map slack variables

expr_h_e = s-s_max;
lh_e = -1e3; %[m]
uh_e = 0; %[m]
% Jsh_e = zeros(1,1);       %map slack variables


% % MIXED INPUT-STATE CONSTRAINTS lg <= C*x + D*u <= ug
% C = [];
% D = [];
% lg = [];
% ug = [];
% J_sg = [];
% 
% C_e = [];
% lg_e = [];
% ug_e = [];
% J_sg_e = [];

%% cost
w_s = 0;
w_v = 10;
w_a = 1;
w_j = 1;
Q = diag([w_s,w_v,w_a]);
P = Q;
R = w_j;
x_ref = vertcat(0,v_ref,0);
u_ref = 0;
% EXTERNAL COST
expr_ext_cost = (sym_x-x_ref)'* Q * (sym_x-x_ref) + (sym_u-u_ref)' * R * (sym_u-u_ref); %stage
expr_ext_cost_e = (sym_x-x_ref)'* P * (sym_x-x_ref); %terminal

% debug
% cost_fun = Function('cost_fun',{s,v,a,j,v_ref},{expr_ext_cost});
% cost_fun(10,0,0,0,10);

% % NONLINEAR LEAST SQUARES
% cost_expr_y = vertcat(sym_x-x_ref, sym_u-u_ref);
% W = blkdiag(W_x, W_u);
% y_ref = [];
% model.cost_expr_y_e = sym_x-x_ref;
% model.W_e = W_x;
% y_ref_e = [];

% % LINEAR LEAST SQUARES
% Vx = [];
% Vu = [];
% Vz = [];
% W = [];
% y_ref = [];
% 
% Vx_e = [];
% W_e = [];
% y_ref_e = [];

%% slack variables cost
% % L2 COST (quadratic)
% Zl = diag([]);
% Zu = diag([]);
% Zl_e = diag([]);
% Zu_e = diag([]);

% % L1 COST (linear)
% zl = [];
% zu = [];
% zl_e = [];
% zu_e = [];

%% populate structures
model.name = 'long_control';
model.nx = nx;
model.nu = nu;
model.sym_x = sym_x;
model.sym_xdot = sym_xdot;
model.sym_u = sym_u;
model.sym_p = sym_p;
model.expr_f_expl = expr_f_expl;
model.expr_f_impl = expr_f_impl;

constraints.expr_h = expr_h;
constraints.lh = lh;
constraints.uh = uh;
constraints.expr_h_e = expr_h_e;
constraints.lh_e = lh_e;
constraints.uh_e = uh_e;
constraints.Jbx = Jbx;
constraints.lbx = lbx;
constraints.ubx = ubx;
constraints.Jbx_e = Jbx_e;
constraints.lbx_e = lbx_e;
constraints.ubx_e = ubx_e;
constraints.Jbu = Jbu;
constraints.lbu = lbu;
constraints.ubu = ubu;
constraints.x0 = x0;

cost.expr_ext_cost = expr_ext_cost;
cost.expr_ext_cost_e = expr_ext_cost_e;

% cost.cost_expr_y = cost_expr_y;
% cost.W = W;

end
