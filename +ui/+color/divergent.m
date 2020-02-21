function cm = divergent(cmax,cmin,cmid,m)
% Divergent linear color map
%
% FORMAT cm = ui.color.divergent(CMAX,CMIN,[CMID],[M])
% CMAX - Color of maximum value (color name or RGB)
% CMIN - Color of minimum value (color name or RGB)
% CMID - Color of middle value (color name or RGB) (default: 'white')
% M    - Length of colormap (default: same as current colormap)
% 
% To reset the colormap of the current figure:
% >> colormap(ui.color.divergent('b','r'));

% --- defaults
if nargin < 3 || any(~isfinite(cmid))
    cmid = [1 1 1];
end
if nargin < 4 || ~isfinite(m)
    f = get(groot,'CurrentFigure');
    if isempty(f)
        m = size(get(groot,'DefaultFigureColormap'),1);
    else
       m = size(f.Colormap,1);
    end
end
m  = floor(m);
hm = floor(m/2);

% --- convert color names to RGB
if ischar(cmin), cmin = ui.color.name2rgb(cmin); end
if ischar(cmax), cmax = ui.color.name2rgb(cmax); end
if ischar(cmid), cmid = ui.color.name2rgb(cmid); end
cmin = cmin(:)';
cmax = cmax(:)';
cmid = cmid(:)';

% --- create linear half spaces
cmneg = [linspace(cmin(1), cmid(1), hm)
         linspace(cmin(2), cmid(2), hm)
         linspace(cmin(3), cmid(3), hm)]';
cmpos = [linspace(cmid(1), cmax(1), hm)
         linspace(cmid(2), cmax(2), hm)
         linspace(cmid(3), cmax(3), hm)]';

% --- concatenate half-spaces
if mod(m,2)
    cm = [cmneg; cmmid; cmpos];
else
    cm = [cmneg; cmpos];
end
