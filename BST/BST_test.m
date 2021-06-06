clc; clear all; close all;
%% Initialization of a square of targets
N = 9;
a = sqrt(N);  % Side length of the square
% Tars(N) = [];
for i = 1:N
    m = floor((i+a-1)/a);
    n = rem((i-1), a)+1;
    if i <= N/2
%         Tars(m, n) = TargetPoint('robot', i, [m, n]);
        Tars(i) = TargetPoint('robot', i, [m, n]);
    else
%         Tars(m, n) = TargetPoint('object', i, [m, n]);
        Tars(i) = TargetPoint('object', i, [m, n]);
    end
%     loc(i, :) = [m n];
%     id(i,:) = Tars(i).ID;
end

all_tar = TargetGroup(Tars);
dim = all_tar.Boundary;
tar_tree = tree(all_tar);

%% Fit tree
% ctree = fitctree(loc, id);
% % view(ctree);
% view(ctree,'mode','graph') % graphic description

tar_tree = TargetToTree(all_tar, tar_tree, 1, 0);
plot(tar_tree);

%% 
% option = 0 means cut vertically
% option = 1 means cut horizontally
function tree = TargetToTree(cur_root, tree, node_idx, option)
    if cur_root.Size == 1
%         return tree;
    else
%         [tar_left, tar_right] = cur_root.TargetSplitting(option);
        tar_child(2) = TargetGroup();
        [tar_child(1), tar_child(2)] = cur_root.TargetSplitting(option);
%         disp(tar_left);
%         disp(tar_right);
        id = [];
        [tree, id(1)] = tree.addnode(node_idx, tar_child(1));
        [tree, id(2)] = tree.addnode(node_idx, tar_child(2));
%         disp(tree);
        change_options = [tar_child(1).CanBeSplit(); tar_child(2).CanBeSplit()];
%         change_options(1,:) = tar_left.CanBeSplit();
%         change_options(2,:) = tar_right.CanBeSplit();
        for i = 1:2
            if all(change_options(i, :))
                tree = TargetToTree(tar_child(i), tree, id(i), ~option);
            elseif change_options(i, 1)
                tree = TargetToTree(tar_child(i), tree, id(i), 0);
            elseif change_options(i, 2)
                tree = TargetToTree(tar_child(i), tree, id(i), 1);
            end
%         if all(change_options(2, :))
%             tree = TargetToTree(tar_right, tree, id_right, ~option);
%         elseif change_options(2, 1)
%             tree = TargetToTree(tar_right, tree, id_right, 0);
%         elseif change_options(2, 2)
%             tree = TargetToTree(tar_right, tree, id_right, 1);
%         end
        end
    end
end

% %% Split the current target group into two sub-groups
% function [tar_left, tar_right] = TargetSplitting(tar_group, option)
%     if option
%         % Cut vertically
%         
%     else
%         % Cut horizontally
%         
%     end
% end
