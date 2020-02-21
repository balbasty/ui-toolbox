function cm = divergent(scheme,m)
% Divergent linear color map from ColorBrewer
%
% FORMAT cm = ui.color.brewer.divergent([SCHEME],[M])
% SCHEME - Name or index of ColorBrewer's divergent scheme (default: 1)
% M      - Length of colormap (default: same as current colormap)
% 
% Available schemes are:
%   1: Spectral
%   2: RdYlGn
%   3: RdBu
%   4: PiYG
%   5: PRGn
%   6: RdYlBu
%   7: BrBG
%   8: RdGy
%   9: PuOr
%
% This function uses ColorBrewer's 3 class scheme to define cmin/cmax/cmid
% and interpolates between these values using ui.color.divergent.
%
% To reset the colormap of the current figure:
% >> colormap(ui.color.brewer.divergent);
% >> colormap(ui.color.brewer.divergent(2));
% >> colormap(ui.color.brewer.divergent('RdBu'));
% >> colormap(ui.color.brewer.divergent('RdBu', 128));

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
schemes = {'spectral' 'RdYlGn' 'RdBu' 'PiYG' 'PRGn' 'RdYlBu' 'BrBG' 'RdGy' 'PuOr'};
if ischar(scheme)
    scheme = find(strcmpi(scheme, schemes), 1);
end
rgb     = [[153 213 148] [255 255 191] [252 141  89]
           [145 207  96] [255 255 191] [252 141  89]
           [103 169 207] [247 247 247] [239 138  98]
           [161 215 106] [247 247 247] [233 163 201]
           [127 191 123] [247 247 247] [175 141 195] 
           [145 191 219] [255 255 191] [252 141  89]
           [ 90 180 172] [245 245 245] [216 179 101]
           [153 153 153] [255 255 255] [239 138  98]
           [153 142 195] [247 247 247] [241 163  64]];
rgb = rgb/255;
rgb = reshape(rgb, size(rgb,1), 3, 3);
rgb = permute(rgb, [3 2 1]);

% --- select appropriate color scheme
rgb = rgb(:,:,scheme);

cm = ui.color.divergent(rgb(3,:), rgb(1,:), rgb(2,:), m);