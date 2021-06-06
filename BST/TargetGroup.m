classdef TargetGroup < handle
    % Group of all targets
    properties (Access = public)
        TargetList  (:, 1)  TargetPoint   % An array of target pointers
        Boundary    (2, 2)  double        % Rectangular boundary
        Size        (1, 1)  int32         % Number of targets
    end
    
    methods (Access = public)
        function obj = TargetGroup(target_lst)
            if nargin > 0
                obj.TargetList = target_lst;
                obj.Size = length(target_lst);
                all_loc = [target_lst.Location];
                obj.Boundary(1, :) = [min(all_loc(1, :)), max(all_loc(1, :))];
                obj.Boundary(2, :) = [min(all_loc(2, :)), max(all_loc(2, :))];
            else
%                 disp('here');
%                 obj.TargetList = [];
                obj.Size = 0;
                obj.Boundary = [0, 0; 0, 0];
            end
        end
        
        function obj = AddTarget(obj, target)
            % Add to the target list.
            obj.TargetList = [obj.TargetList; target];
            obj.Size = obj.Size + 1;
            % Update the boundary.
            if all(all(obj.Boundary == [0 0; 0 0]))
                obj.Boundary = [target.Location target.Location];
            else
                obj.Boundary(:, 1) = min(obj.Boundary(:, 1), target.Location);
                obj.Boundary(:, 2) = max(obj.Boundary(:, 2), target.Location);
            end
        end
        
        function [tar_left, tar_right] = TargetSplitting(obj, option)
%             j = 1;
%             temp_mul = [];
            for i = (obj.Boundary(option+1, 1)+1):obj.Boundary(option+1, 2)
                [temp_l, temp_r] = obj.GetSplitNum(i, option);
%                 disp("left");
%                 disp(temp_l);
%                 disp("right");
%                 disp(temp_r);
                temp_mul(i) = temp_l * temp_r;
%                 disp("multiple");
%                 disp(temp_mul);
%                 j = j + 1;
            end
            [~, i] = max(temp_mul);
%             disp("max index");
%             disp(i);
            [tar_left, tar_right] = obj.GetSplitGroup(i, option);
        end
        
        function result = CanBeSplit(obj)
            if obj.Boundary(1, 2) - obj.Boundary(1, 1) >= 1
                result(1) = true;
            else
                result(1) = false;
            end
            if obj.Boundary(2, 2) - obj.Boundary(2, 1) >= 1
                result(2) = true;
            else
                result(2) = false;
            end
        end
    end
    
    methods (Access = private)
        function [nl, nr] = GetSplitNum(obj, pos, option)
            nl = 0;  % Left or lower part
            nr = 0;  % Right or upper part
%             if option
%                 % Cut vertically
            for i = 1:obj.Size
                if obj.TargetList(i).Location(option+1) < pos
                    nl = nl + 1;
                else
                    nr = nr + 1;
                end
            end
%             else
%                 % Cut horizontally
%                 
%             end
        end
        
        function [tar_l, tar_r] = GetSplitGroup(obj, pos, option)
            tar_l = TargetGroup();  % Left or lower targets
            tar_r = TargetGroup();  % Right or upper targets
            for i = 1:obj.Size
                tar = obj.TargetList(i);
                if tar.Location(option+1) < pos
                    tar_l.AddTarget(tar);
                else
                    tar_r.AddTarget(tar);
                end
            end
        end
        
    end
end
