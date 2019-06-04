function [PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = ...
               spec_add_0216(A, sigma2, Anoise, sigma2noise)

%
% [PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = ...
%                 spec_add(A, sigma2, Anoise, sigma2noise)
%	
%	A		- AR model for the signal x(n), A(q)x(n)=w(n)
%	sigma2		- E[w(n)*w(n)]
%	Anoise		- AR model for the noise v(n), Anoise(q)v(n)=e(n)
%	sigma2noise	- E[e(n)*e(n)]
%	
% 	PhixyNum,PhixyDen	- Cross-spectrum between x(n) and y(n)
% 	PhiyyNum,PhiyyDen	- Spectrum of y(n)
%	
%  spec_add: Calculate spectrum and cross-spectrum for y(n)=x(n)+v(n)
%     
%     
%     Author:
%
[PhiNumxx,PhiDenxx] = filtspec(1,A,sigma2);
[PhiNumqq,PhiDenqq] = filtspec(1,Anoise,sigma2noise);

PhixyNum = PhiNumxx;
PhixyDen = PhiDenxx;
[PhiyyNum,PhiyyDen] = add(PhiNumxx,PhiDenxx,PhiNumqq,PhiDenqq);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


