function [val]= muller(fun,ply,N,Init,tol,maxIter,imagRoots)
% function [val]= muller(fun,ply,N,Init,tol,maxIter,imagRoots) find roots of fun
% Uses the Muller1 method to solve for a root of f(x) and puts them in ply object
%
% Find a solution to f(x) = 0 given three approximations p0, p1
% and p2 (Note that the Muller1 method may return complex roots)
%
%  INPUT:
%   fun is the function we wish to find the roots of.
%   ply is a polyClass object. The roots should initially be [].
%   N is the number of roots looked for.
%   Init is a vector with initial values for p0, p1, and p2
%   Make sure this is correct.
%   tol: is the solution tolerence
%   maxIter: is the maximum number of iterations.
%
%   OUTPUT: val: is the value of fun at the roots found
%      table: is the iteration table
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.

  if nargin < 7
      imagRoots = 0;
  end



  %intitialize output variables
  root_ = [];
  val = [];
  table ={};


  %% Based on Algorithm 2.7 from Numerical Analysis, Burden and Faires
  %% and matlabcentral/filexchange code by John Mathews with modifications
  %% by Kenneth Martin
  
  %Step 1
  minDenom = 1e-15;
  maxFun = 1e40;
  ply.K = 1;

  dfltfun = @(s) (fun(s)./(ply.peval(s) + 1e-24));

  p0 = Init(1);
  p1 = Init(2);
  p2 = Init(3);

  fun0 = dfltfun(p0);
  fun1 = dfltfun(p1);
  fun2 = dfltfun(p2);

  h1 = p1 - p0;
  h2 = p2 - p1;
  del1 = (fun1-fun0)./h1;
  del2 = (fun2-fun1)./h2;
  d = (del2-del1)./(h2+h1);
  I = 3;

  for rtNmb = 1:N

    %Step 2
    while I <= maxIter
      %Step 3
      b = del2+h2.*d;
      D = sqrt(b.^2-4.*fun2.*d); % could be complex
      %Step 4
      if abs(b - D) < abs(b + D)
        E = b + D;
      else
        E = b - D;
      end
      %Step 5
      h = -2.*fun2./(E + 1e-16j);
      %if h > 10 h=10; end
      %if h < -10 h=-10; end
      %if imagRoots
      %  h = imag(h)*j;
      %end

      if abs(h) < 1e-15
        table = char(table);
        root_ = p;
        break
      end

      p = p2 + h;

      %if imagRoots && I > 20
      %  p = imag(p)*j;
      %end
      
      if I == 3
        table{1} = 'Muller1''s Method Iterations';
        table{2}='  I       P           f(P)       ';
        table{3}='-----------------------------------------------------';
      end
      str = sprintf('%3u:  % 6.6f + %6.6fi % 6.6f + %6.6fi',I,real(p),imag(p),real(fun(p)),imag(fun(p)));
      table{I + 1} = str;
      
      %Step 6
      if abs(h) < tol && abs(dfltfun(p)) < 1e-7
        table = char(table);
        root_ = p;
        break
      end

      p0 = p1;
      p1 = p2;
      p2 = p;

      %if (abs(p2) > 25) % start over
      %  p0 = Init(1);
      %  p1 = Init(2);
      %  p2 = Init(3);
      %end

      %[rt, indx] = min(abs(p - ply.rts));
      %nrstRt = ply.rts(indx);
      %if indx ~= 0
      %  deflate = 1/(100*(p - nrstRt));
      %else
      %  deflate = 1;
      %end

      ply_p2 = ply.peval(p2)/ply.K; % evaluate ply given roots already found
      while (ply_p2 ~= 0) && (abs(ply_p2) < minDenom) % don't let route deflation get too small
        ply_p2 = ply_p2*2;
      end
      %fun0 = fun1;
      %fun1 = fun2;
      %fun0 = fun(p0)/ply.peval(p0);
      %fun1 = fun(p1)/ply.peval(p1);
      %fun2 = fun(p2)/ply.peval(p2);
      fun0 = dfltfun(p0);
      fun1 = dfltfun(p1);
      fun2 = dfltfun(p2);

      if (abs(fun2) > 1e-5 && (abs(fun1 - fun0) < tol) && (abs(fun2 - fun1) < tol))
          % when all functions have the same values, there are probably no
          % zeros
          root_ = nan;
        break;
      end

      if (abs(fun2) > maxFun) % there are probably no more roots
        break;
      end
  
      h1 = p1 - p0;
      h2 = p2 - p1;

      if abs(h2 + h1) < 1e-15
        table = char(table);
        root_ = p;
        break
      end

      del1 = (fun1-fun0)./(h1);
      del2 = (fun2-fun1)./(h2);
      d = (del2-del1)./(h2 + h1);
      I = I + 1;
    end

    if (rtNmb < N && abs(fun2) > maxFun) % there are probably no more roots
      ply.K = sign(real(fun2) + imag(fun2));
      display(sprintf('Returning after finding %d roots', rtNmb))
      break;
    end
  
    if (I < maxIter && ~isnan(root_))
      if imagRoots
        root_ = imag(root_)*j;
      end
      ply.addRoot(root_);
      if ply.N > 2
        isEqual = chckEqlOrdr(ply, fun);
      else
        isEqual = 0;
      end
      if isEqual
        break;
      end
    else
      break;
    end

    %table
    table ={};

    p0 = Init(1);
    p1 = Init(2);
    p2 = Init(3);

    fun0 = dfltfun(p0);
    fun1 = dfltfun(p1);
    fun2 = dfltfun(p2);

    h1 = p1 - p0;
    h2 = p2 - p1;
    del1 = (fun1-fun0)./h1;
    del2 = (fun2-fun1)./h2;
    d = (del2-del1)./(h2+h1);
    I = 3;

  end

  %ply.cleanRts();
  ply.K = 1*sign(ply.K); % Muller1 does not preserve magnitude so normalize and adjust K separately
  if ply.N ~= 0
    for rt = ply.rts
      val = [val fun(rt)];
    end
  else
    val = 0;
  end

  % polish roots using original function
  if ply.N > 1
      rts = ply.rts;
      N = ply.N;

      % Estimate the leading coefficient of fun at a point away from roots.
      % ply.K is now +/-1, so ply.peval(s) is the monic root polynomial.
      if N >= 2
          ind1 = floor(N/2);
          ind2 = ind1 + 1;
          s_eval = (rts(ind1) + rts(ind2)) / 2;
      elseif N == 1
          s_eval = rts(1) * 1.5;
      else
          s_eval = 0;
      end
      indic = find(abs(rts - s_eval) < 1e-4);
      while ~isempty(indic)
          s_eval = s_eval + 0.2j;
          indic = find(abs(rts - s_eval) < 1e-4);
      end
      K_fun = fun(s_eval) / (sign(ply.K) * ply.peval(s_eval));

      % Use the monic residual so the safeguard is not fooled by the
      % enormous scale of the original polynomial.
      res0 = max(abs(fun(rts) / K_fun));
      % Tolerance for declaring convergence to machine precision.
      updTol = 1e-12 * max(1, max(abs(rts)));
      for i=1:4
        pl1 = poly(rts);
        [p pDer] = plyDer(pl1, rts);
        funRts = fun(rts);
        update = funRts ./ (K_fun * pDer);
        new_rts = rts - update;
        new_res = max(abs(fun(new_rts) / K_fun));
        if new_res < res0 || max(abs(update)) < updTol
            rts = new_rts;
            res0 = new_res;
            if max(abs(update)) < updTol
                break;
            end
        else
            break;
        end
      end
      ply.rts = rts;
  end

  if isempty(root_) || rtNmb > N
    st = dbstack(2);
    if ~isempty(st)
        caller = sprintf('%s:%d', st(1).name, st(1).line);
    else
        caller = 'toplevel';
    end
    fprintf('MULLER_UNSUCCESSFUL: requested N=%d, found %d roots (caller %s)\n', ...
        N, ply.N, caller);
    table = char(table);
  end
end