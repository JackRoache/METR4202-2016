function e=M_rot2eu(m,ro)

e=zeros(3,1);
if ischar(m)
    m=lower(m)-'w';
end
if numel(m)~=3 | any(abs(m-2)>1), error('Euler axis must be an x,y or z triplet'); end
u=m(1);
v=m(2);
w=m(3);
if sum(m==v)>1, error('Consecutive Euler axes must differ'); end
% first we rotate around w to null element (v,u) with respect to element (!vw,u) of rotation matrix
g=2*mod(u-v,3)-3;   % +1 if v follows u or -1 if u follows v
h=2*mod(v-w,3)-3;   % +1 if w follows v or -1 if v follows w
[s,c,r,e(3)]=atan2sc(h*ro(v,u),ro(6-v-w,u));
r2=ro;
ix=1+mod(w+(0:1),3);
r2(ix,:)=[c s; -s c]*ro(ix,:);
% next we rotate around v to null element (!uv,u) with repect to element (u,u) of rotation matrix
e(2)=atan2(-g*r2(6-u-v,u),r2(u,u));
% finally we rotate around u to null element (v,!uv) with respect to element (!uv,!uv) = element (v,v)
e(1)=atan2(-g*r2(v,6-u-v),r2(v,v));
if (u==w && e(2)<0) || (u~=w && abs(e(2))>pi/2)  % remove redundancy
    mk=u~=w;
    e(2)=(2*mk-1)*e(2);
    e=e-((2*(e>0)-1) .* [1; mk; 1])*pi;
end


function [s,c,r,t]=atan2sc(y,x)
t=NaN;
if y == 0
    t=(x<0);
    c=1-2*t;
    s=0;
    r=abs(x);
    t=t*pi;
elseif x == 0
    s=2*(y>=0)-1;
    c=0;
    r=abs(y);
    t=s*0.5*pi;
elseif (abs(y) > abs(x))
    q = x/y;
    u = sqrt(1+q^2)*(2*(y>=0)-1);
    s = 1/u;
    c = s*q;
    r = y*u;
else
    q = y/x;
    u = sqrt(1+q^2)*(2*(x>=0)-1);
    c = 1/u;
    s = c*q;
    r = x*u;
end
if nargout>3 && isnan(t)
    t=atan2(s,c);
end
