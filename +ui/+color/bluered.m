function cm = bluered(varargin)
% Divergent linear color map (blue/white/red)
%
% FORMAT cm = ui.color.bluered([M])
% M - Length of colormap (default: same as current colormap)
% 
% To reset the colormap of the current figure:
% >> colormap(ui.color.bluered);

cm = ui.color.divergent('r', 'b', 'w', varargin{:});
