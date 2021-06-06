classdef TargetPoint < handle
    % A single target point
    properties (Access = public)
        % Can be directly modified by the user.
        ID            (1, 1) int32 {mustBeNonnegative}  % ID of the target point
        Location      (2, 1) double  % Current target position
        NextPosition  (2, 1) double  % Next position of the target point
        PrevPositions (2, :) double  % Previous positions of the target point
    end
    
    properties (Access = private)
        % Cannot be directly modified after assignment
        Type         (1, 1) string  % Robot/Object
    end
    
    methods (Access = public)
        % Constructor function
        function obj = TargetPoint(type, id, loc, nextPos, prevPos)
            if nargin == 0
                error("User needs to specify the type at least.");
            end
            if nargin >= 1
                % Assign type
                if (type == "Robot") || (type == "robot")
                    obj.Type = "Robot";
                elseif (type == "Object") || (type == "object")
                    obj.Type = "Object";
                else
                    error("Invaild input of type.");
                end
            end
            if nargin >= 2
                obj.ID = id;  % Assign ID
            end
            if nargin >= 3
                obj.Location = loc;  % Assign location
            end
            if nargin >= 4
                obj.NextPosition = nextPos;  % Assign next position
            end
            if nargin == 5
                obj.PrevPositions = prevPos;  % Assign previous positions
            end
        end
        
        function type = GetType(obj)
            type = obj.Type;
        end
        
%         function id = GetID(obj)
%             id = obj.ID;
%         end
    end
end

% classdef TargetType
%     enumeration
%         Robot  (1)
%         Object (2)
%     end
% end