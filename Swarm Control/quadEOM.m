function sdot = quadEOM(t, s,controlhandle, trajhandle, params)

qd=stateToQd(s);
desired_state = trajhandle(t);
qd.pos_des      = desired_state.pos;
% qd.pos_des      = desired_state.pos;
% qd.pos_des      = desired_state.pos;
% qd.pos_des      = desired_state.pos;

[F, M, trpy, drpy] = controlhandle(qd, t, qn, params);
sdot = quadEOM_readonly(t, s, F, M, params);
end
