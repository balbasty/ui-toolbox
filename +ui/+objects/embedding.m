classdef embedding < uipanel
    properties (AbortSet, SetObservable)
        Position
        Units
        Offset
        OffsetUnits
        OriginSide
    end
    properties (Constant = true)
        Type = 'ui.objects.embedding'
    end
    properties (Access = public) % protected
        callbacks
    end
    methods
        function obj = embedding(varargin)
            obj             = obj@uipanel(varargin{:});
            opt             = getoptions(obj, varargin);
            obj.Position    = opt.Position;
            obj.Units       = opt.Units;
            obj.Offset      = opt.Offset;
            obj.OffsetUnits = opt.OffsetUnits;
            obj.OriginSide  = opt.OriginSide;
            
            obj.BorderType  = 'none';
            obj.BorderWidth = 0;
            obj.Title       = '';
            Visible         = obj.Visible;
            obj.Visible     = 'off';
            
            obj.SizeChangedFcn = @(s,e) multicallbacks(s, e, obj.callbacks);
            obj.callbacks = {};
            obj.callbacks{1} = @(s,e) resizecallback(obj);
            addlistener(obj, 'Position',    'PostSet', @(s,e) resizecallback(obj));
            addlistener(obj, 'Units',       'PostSet', @(s,e) resizecallback(obj));
            addlistener(obj, 'Offset',      'PostSet', @(s,e) resizecallback(obj));
            addlistener(obj, 'OffsetUnits', 'PostSet', @(s,e) resizecallback(obj));
            addlistener(obj, 'OriginSide',  'PostSet', @(s,e) resizecallback(obj));
            
            obj.Visible = Visible;
        end
        function obj = addCallback(obj, cb)
            obj.callbacks{end+1} = cb;
        end
    end
    methods (Access = private)
        function opt = getoptions(~, in)
            % Default values
            opt                         = struct;
            opt.Parent                  = 0;
            opt.HorizontalOrigin        = 0;
            opt.HorizontalOriginSide    = 'left';
            opt.HorizontalOriginUnit    = 'normalized';
            opt.VerticalOrigin          = 0;
            opt.VerticalOriginSide      = 'bottom';
            opt.VerticalOriginUnit      = 'normalized';
            opt.Width                   = 1;
            opt.WidthUnit               = 'normalized';
            opt.Height                  = 1;
            opt.HeightUnit              = 'normalized';
            opt.WidthOffset             = 0;
            opt.WidthOffsetUnit         = 'pixels';
            opt.HeightOffset            = 0;
            opt.HeightOffsetUnit        = 'pixels';
            
            % Parse
            opt = parse_varargin(in{:}, opt);
            
            % Post processing
            if ~(ishandle(opt.Parent) && (...
                    strcmp(get(opt.Parent, 'type'), 'figure') || ...
                    strcmp(get(opt.Parent, 'type'), 'uipanel')) )
                opt.Parent = figure;
            end
            if isfield(opt, 'Position')
                opt.HorizontalOrigin        = opt.Position(1);
                opt.VerticalOrigin          = opt.Position(2);
                opt.Width                   = opt.Position(3);
                opt.Height                  = opt.Position(4);
            end
            if isfield(opt, 'Unit')
                opt.HorizontalOriginUnit    = opt.Unit(1);
                opt.VerticalOriginUnit      = opt.Unit(2);
                opt.WidthUnit               = opt.Unit(3);
                opt.HeightUnit              = opt.Unit(4);
            end
            if isfield(opt, 'Origin')
                opt.HorizontalOrigin        = opt.Origin(1);
                opt.VerticalOrigin          = opt.Origin(end);
            end
            if isfield(opt, 'OriginUnit')
                opt.HorizontalOriginUnit    = opt.OriginUnit;
                opt.VerticalOriginUnit      = opt.OriginUnit;
            end
            if isfield(opt, 'Size')
                opt.Width                   = opt.Size(1);
                opt.Height                  = opt.Size(end);
            end
            if isfield(opt, 'SizeUnit')
                opt.WidthUnit               = opt.SizeUnit;
                opt.HeightUnit              = opt.SizeUnit;
            end
            if isfield(opt, 'OffsetUnit')
                opt.WidthOffsetUnit         = opt.OffsetUnit;
                opt.HeightOffsetUnit        = opt.OffsetUnit;
            end
        end
    end
    methods (Access = protected)
        function obj = unfreezeCallback(obj)
            obj.uipanel.SizeChangedFcn = @(s,e) multicallbacks(s, e, obj.callbacks);
        end
        function obj = freezeCallback(obj)
            obj.uipanel.SizeChangedFcn = '';
        end
    end
end

%% Callback util
function multicallbacks(src, event, callbacks)
% Helper to concatenate multiple callback functions
    for i=1:numel(callbacks)
        callbacks{i}(src, event);
    end
end

%% CALLBACKS
function resizecallback(obj)
% Actual resizing function
    freezeCallback(obj);
    units = obj.uipanel.Units;
    obj.uipanel.Units = 'normalized';
    obj.uipanel.Position = [0 0 1 1];
    obj.uipanel.Units = 'pixels';
    contpos = obj.uipanel.Position;
    newpos = zeros([1 4]);
    switch obj.WidthUnit
        case 'normalized'
            switch obj.WidthOffsetUnit
                case 'normalized'
                    newpos(3) = contpos(3) * obj.Width * (1 - obj.WidthOffset);
                case 'pixels'
                    newpos(3) = (contpos(3) - obj.WidthOffset) * obj.Width;
            end
        case 'pixels'
            switch obj.WidthOffsetUnit
                case 'normalized'
                    newpos(3) = obj.Width - contpos(3) * obj.WidthOffset;
                case 'pixels'
                    newpos(3) = obj.Width - obj.WidthOffset;
            end
    end
    switch obj.HeightUnit
        case 'normalized'
            switch obj.HeightOffsetUnit
                case 'normalized'
                    newpos(4) = contpos(4) * obj.Height * (1 - obj.HeightOffset);
                case 'pixels'
                    newpos(4) = (contpos(4) - obj.HeightOffset) * obj.Height;
            end
        case 'pixels'
            switch obj.HeightOffsetUnit
                case 'normalized'
                    newpos(4) = obj.Height - contpos(4) * obj.HeightOffset;
                case 'pixels'
                    newpos(4) = obj.Height - obj.HeightOffset;
            end
    end
    switch obj.HorizontalOriginUnit
        case 'normalized'
            switch obj.HorizontalOriginSide
                case 'left'
                    newpos(1) = contpos(1) + obj.HorizontalOrigin * contpos(3);
                case 'right'
                    newpos(1) = contpos(1) - newpos(3) + (1 - obj.HorizontalOrigin) * contpos(3);
            end
        case 'pixels'
            switch obj.HorizontalOriginSide
                case 'left'
                    newpos(1) = contpos(1) + obj.HorizontalOrigin;
                case 'right'
                    newpos(1) = contpos(1) + contpos(3) - newpos(3) - obj.HorizontalOrigin;
            end
    end
    switch obj.VerticalOriginUnit
        case 'normalized'
            switch obj.VerticalOriginSide
                case 'bottom'
                    newpos(2) = contpos(1) + obj.VerticalOrigin * contpos(4);
                case 'top'
                    newpos(2) = contpos(2) - newpos(4) + (1 - obj.VerticalOrigin) * contpos(4);
            end
        case 'pixels'
            switch obj.VerticalOriginSide
                case 'bottom'
                    newpos(2) = contpos(2) + obj.VerticalOrigin;
                case 'top'
                    newpos(2) = contpos(2) + contpos(4) - newpos(4) - obj.VerticalOrigin;
            end
    end
    obj.uipanel.Position = newpos;
    obj.uipanel.Units = units;
    unfreezeCallback(obj);
end