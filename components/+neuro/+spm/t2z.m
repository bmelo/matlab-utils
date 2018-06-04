%
% Usage:  T_to_Z(Tval, dof)
%
% This script uses a T value to convert to Z value
%
%  Args:
%  Tval -- double number
%  dof -- degrees of freedom
%
% Created by:           Bruno Melo
% Modification date:    Jun. 6, 2018
%
function Zval = T_to_Z( Tval, dof )

Zval = abs(norminv(tcdf( Tval, dof, 'upper'),0,1));