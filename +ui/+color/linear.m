function cm = linear(cmax,cmin,m)
% Linear color map
%
% FORMAT cm = ui.color.divergent(CMAX,[CMIN],[M])
% CMAX - Color of maximum value (color name or RGB)
% CMIN - Color of minimum value (color name or RGB) (default: 'white')
% M    - Length of colormap (default: same as current colormap)
% 
% To reset the colormap of the current figure:
% >> colormap(ui.color.linear('b'));

% --- defaults
if nargin < 2 || any(~isfinite(cmin))
    cmin = [1 1 1];
end
if nargin < 3 || ~isfinite(m)
    f = get(groot,'CurrentFigure');
    if isempty(f)
        m = size(get(groot,'DefaultFigureColormap'),1);
    else
       m = size(f.Colormap,1);
    end
end
m  = floor(m);

% --- convert color names to RGB
if ischar(cmin), cmin = ui.color.name2rgb(cmin); end
if ischar(cmax), cmax = ui.color.name2rgb(cmax); end
cmin = cmin(:)';
cmax = cmax(:)';

% --- create colormap
cm = [linspace(cmin(1), cmax(1), m)
      linspace(cmin(2), cmax(2), m)
      linspace(cmin(3), cmax(3), m)]';