function cm = categorical(scheme,m,rnd)
% Categorical color map from ColorBrewer
%
% FORMAT cm = ui.color.brewer.categorical([SCHEME],[M],[RND])
% SCHEME - Name or cell of conditions or index of ColorBrewer's 
%          categorical scheme (default: 1)
% M      - Length of colormap (default: same as current colormap)
% RND    - Select colors randomly in the full set [false] 
%
% Available schemes are:
%    1: Set1
%    2: Set2
%    3: Set3
%    4: Pastel1
%    5: Pastel2
%    6: Dark2
%    7: Accent
%    8: Paired
%
% Available conditions are: 'blind' 'print' 'copy' 'screen'
%
% To reset the colormap of the current figure:
% >> colormap(ui.color.brewer.categorical);
% >> colormap(ui.color.brewer.categorical(2));
% >> colormap(ui.color.brewer.categorical('Pastel1'));
% >> colormap(ui.color.brewer.categorical({'blind' 'screen'}, 3));

% TODO: allow hard or soft conditions ('mandatory', 'preferred', ...)

% --- defaults
if nargin < 1 || (isscalar(scheme) && ~isfinite(scheme))
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
if nargin < 3 || ~isfinite(rnd)
    rnd = false;
end
m  = floor(m);

% --- available schemes
schemes = {'Set1' 'Set2' 'Set3' 'Pastel1' 'Pastel2' 'Dark2' 'Accent' 'Paired'};
blind   = [1 4 2 1 1 4 1 6];
print   = [1 6 7 3 1 1 6 9];
copy    = [0 0 7 0 0 0 0 9];
screen  = [1 6 6 4 2 1 6 9];
maxcat  = [9 8 12 9 8 8 8 12];
rgb     = {[[228  26  28] [ 55 126 184] [ 77 175  74] [152  78 163] [255 127   0] [255 255  51] [166  86  40] [247 129 191] [153 153 153]]
           [[102 194 165] [252 141  98] [141 160 203] [231 138 195] [166 216  84] [255 217  47] [229 196 148] [179 179 179]]
           [[141 211 199] [255 255 179] [190 186 218] [251 128 114] [128 177 211] [253 180  98] [179 222 105] [252 205 229] [217 217 217] [188 128 189] [204 235 197] [255 237 111]]
           [[251 180 174] [179 205 227] [204 235 197] [222 203 228] [254 217 166] [255 255 204] [229 216 189] [253 218 236] [242 242 242]]
           [[179 226 205] [253 205 172] [203 213 232] [244 202 228] [230 245 201] [255 242 174] [241 226 204] [204 204 204]]
           [[ 27 158 119] [217  95   2] [117 112 179] [231  41 138] [102 166  30] [230 171   2] [166 118  29] [102 102 102]]
           [[127 201 127] [190 174 212] [253 192 134] [255 255 153] [ 56 108 176] [240   2 127] [191  91  23] [102 102 102]]
           [[166 206 227] [ 31 120 180] [178 223 138] [ 51 160  44] [251 154 153] [227  26  28] [253 191 111] [255 127   0] [202 178 214] [106  61 154] [255 255 153] [177  89  40]]};
rgb = cellfun(@(X) reshape(X, 3, [])'/255, rgb, 'UniformOutput', false);

% --- convert color names / condition to RGB
if iscell(scheme)
    % condition
    cond = (maxcat >= m);
    allcond = [];
    while ~isempty(scheme)
        switch lower(scheme{1})
            case 'blind'
                cond = cond & (blind >= m);
                allcond = [allcond; blind];
            case 'print'
                cond = cond & (print >= m);
                allcond = [allcond; print];
            case 'copy'
                cond = cond & (copy >= m);
                allcond = [allcond; copy];
            case 'screen'
                cond = cond & (screen >= m);
                allcond = [allcond; screen];
            otherwise
                warning('Unknown condition %s', scheme{1});
        end
        scheme = scheme(2:end);
    end
    scheme = find(cond, 1);
    if isempty(scheme)
        error('No scheme respects all required conditions');
    end
    maxid  = min(allcond(:,scheme));
elseif ischar(scheme)
    % name
    scheme = find(strcmpi(scheme, schemes), 1);
    maxid  = size(rgb{scheme},1);
else
    maxid  = size(rgb{scheme},1);
end

% --- select appropriate color scheme
rgb = rgb{scheme};
if m > maxid
    error('The selected scheme is only appropriate for up to %d categories', maxid);
end
if rnd
    idx = randsample(maxid, m);
else
    idx = 1:m;
end
cm  = rgb(idx,:);