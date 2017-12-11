function [E, F] = get_matlab_E_F(I1, I2, fc, cc) 
% Function used to compare my own results to the "right ones". Not used in any
% way in the final assigment

matlab_intrinsics = cameraIntrinsics(fc,cc,size(I1));
matlab_cam_params = cameraParameters('IntrinsicMatrix', matlab_intrinsics.IntrinsicMatrix);
[matched_points1, matched_points2] = get_matched_pts(I1, I2);

F = estimateFundamentalMatrix(matched_points1(1:2,:)', matched_points2(1:2,:)';
E = estimateEssentialMatrix(matched_points1(1:2,:)', matched_points2(1:2,:)', matlab_cam_params);

