%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Hardik Y. Patil                                                      %
% Email: hardikyp@umich.edu                                                    %
% Date: March 2, 2026                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function calculates the index of the control degree of freedom 
% for specifying a prescribed displacement in the displacement control solver
% when the dofs are organized in a column vector format.
% 
% Inputs:
% -------
% nodeNum (int): Control DOF's node number
% dofNum (int): X (1) or Y(2) DOF to be controlled at nodeNum
% identity (array): (nNodes, nDof)
% nNodes (int): Number of nodes in the system
% nDof (int): Number of degrees of freedom per node (2)
% nFree (int): Number of free degrees of freedom
% 
% Outputs:
% --------
% idxCtrlU (int): Index of the control DOF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function idxCtrlU = controlDisplacement(nodeNum, dofNum, identity, ...
                                        nNodes, nDof, nFree)

    if nodeNum > nNodes
        error('Node specified for control displacement does not exist. Choose between 1 and %d', nNodes);
    end

    if dofNum > nDof
        error('Specified DOF at control node does not exist. Choose between 1 and %d.', nDof);
    end

    idxCtrlU = identity(nodeNum, dofNum);
    if idxCtrlU > nFree
        error('Controlled DOF is restrained/fixed. Choose a free DOF.');
    end
end