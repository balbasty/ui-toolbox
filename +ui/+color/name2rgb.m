function rgb = name2rgb(name)
% Convert MATLAB's default color name to rgb
%
% FORMAT rgb = ui.color.name2rgb(name)

if ischar(name)
    switch lower(name)
        case {'y','yellow'},    rgb = [1 1 0];
        case {'m','magenta'},   rgb = [1 0 1];
        case {'c','cyan'},      rgb = [0 1 1];
        case {'r','red'},       rgb = [1 0 0];
        case {'g','green'},     rgb = [0 1 0];
        case {'b','blue'},      rgb = [0 0 1];
        case {'w','white'},     rgb = [1 1 1];
        case {'k','black'},     rgb = [0 0 0];
        otherwise
            error('Unknown color name %s', name);
    end
end