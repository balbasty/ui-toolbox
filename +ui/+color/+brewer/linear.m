function cm = linear(scheme,m)
% Linear color map from ColorBrewer
%
% FORMAT cm = ui.color.brewer.linear([SCHEME],[M])
% SCHEME - Name or index of ColorBrewer's divergent scheme (default: 1)
% M      - Length of colormap (default: same as current colormap)
% 
% Available schemes are:
%    1: OrRd
%    2: PuBu
%    3: BuPu
%    4: Oranges
%    5: BuGn
%    6: YlOrBr
%    7: YlGn
%    8: Reds
%    9: RdPu
%   10: Greens
%   11: YlGnBu
%   12: Purples
%   13: GnBu
%   14: Greys
%   15: YlOrRd
%   16: PuRd
%   17: Blues
%   18: PuBuGn
%
% This function uses ColorBrewer's 3 class scheme to define cmin/cmax
% and interpolates between these values using ui.color.linear.
%
% To reset the colormap of the current figure:
% >> colormap(ui.color.brewer.linear);
% >> colormap(ui.color.brewer.linear(2));
% >> colormap(ui.color.brewer.linear('Greens'));
% >> colormap(ui.color.brewer.linear('Greens', 128));

% --- defaults
if nargin < 1 || any(~isfinite(scheme))
    scheme = 1;
end
if nargin < 2 || ~isfinite(m)
    f = get(groot,'CurrentFigure');
    if isempty(f)
        m = size(get(groot,'DefaultFigureColormap'),1);
    else
       m = size(f.Colormap,1);
    end
end
m  = floor(m);

% --- convert color names to RGB
schemes = {'OrRd' 'PuBu' 'BuPu' 'Oranges' 'BuGn' 'YlOrBr' 'YlGn' 'Reds' ...
           'RdPu' 'Greens' 'YlGnBu' 'Purples' 'GnBu' 'Greys' 'YlOrRd' ...
           'PuRd' 'Blues' 'PuBuGn'};
if ischar(scheme)
    scheme = find(strcmpi(scheme, schemes), 1);
end
rgb     = [[254 232 200] [227  74  51]
           [236 231 242] [ 43 140 190]
           [224 236 244] [136  86 167]
           [254 230 206] [230  85  13]
           [229 245 249] [ 44 162  95]
           [255 247 188] [217  95  14]
           [247 252 185] [ 49 163  84]
           [254 224 210] [222  45  38]
           [253 224 221] [197  27 138]
           [229 245 224] [ 49 163  84]
           [237 248 177] [ 44 127 184]
           [239 237 245] [117 107 177]
           [224 243 219] [ 67 162 202]
           [240 240 240] [ 99  99  99]
           [255 237 160] [240  59  32]
           [231 225 239] [221  28 119]
           [222 235 247] [ 49 130 189]
           [236 226 240] [ 28 144 153]];
rgb = rgb/255;
rgb = reshape(rgb, size(rgb,1), 3, 2);
rgb = permute(rgb, [3 2 1]);

% --- select appropriate color scheme
rgb = rgb(:,:,scheme);

cm = ui.color.linear(rgb(2,:), rgb(1,:), m);
%    9: RdPu
%   10: Greens
%   11: YlGnBu
%   12: Purples
%   13: GnBu
%   14: Greys
%   15: YlOrRd
%   16: PuRd
%   17: Blues
%   18: PuBuGn
%
% This function uses ColorBrewer's 3 class scheme to define cmin/cmax
% and interpolates between these values using ui.color.linear.
%
% To reset the colormap of the current figure:
% >> colormap(ui.color.brewer.linear);

% --- defaults
if nargin < 1 || any(~isfinite(scheme))
    scheme = 1;
end
if nargin < 2 || ~isfinite(m)
    f = get(groot,'CurrentFigure');
    if isempty(f)
        m = size(get(groot,'DefaultFigureColormap'),1);
    else
       m = size(f.Colormap,1);
    end
end
m  = floor(m);

% --- convert color names to RGB
schemes = {'OrRd' 'PuBu' 'BuPu' 'Oranges' 'BuGn' 'YlOrBr' 'YlGn' 'Reds' ...
           'RdPu' 'Greens' 'YlGnBu' 'Purples' 'GnBu' 'Greys' 'YlOrRd' ...
           'PuRd' 'Blues' 'PuBuGn'};
if ischar(scheme)
    scheme = find(strcmpi(scheme, schemes), 1);
end
rgb     = [[254 232 200] [227  74  51]
           [236 231 242] [ 43 140 190]
           [224 236 244] [136  86 167]
           [254 230 206] [230  85  13]
           [229 245 249] [ 44 162  95]
           [255 247 188] [217  95  14]
           [247 252 185] [ 49 163  84]
           [254 224 210] [222  45  38]
           [253 224 221] [197  27 138]
           [229 245 224] [ 49 163  84]
           [237 248 177] [ 44 127 184]
           [239 237 245] [117 107 177]
           [224 243 219] [ 67 162 202]
           [240 240 240] [ 99  99  99]
           [255 237 160] [240  59  32]
           [231 225 239] [221  28 119]
           [222 235 247] [ 49 130 189]
           [236 226 240] [ 28 144 153]];
rgb = rgb/255;
rgb = reshape(rgb, size(rgb,1), 3, 2);
rgb = permute(rgb, [3 2 1]);

% --- select appropriate color scheme
rgb = rgb(:,:,scheme);

cm = ui.color.linear(rgb(2,:), rgb(1,:), m);