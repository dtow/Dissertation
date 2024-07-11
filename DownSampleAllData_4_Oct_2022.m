%% SECTION 1 - Load Data Structure

%Want to clear the errors for the new section
lasterror = [];

%Load data structure
load( 'Post-Quals Data/Data Structure/Current Version/David_DissertationDataStructure_17_Apr_2024.mat');


%Need to create a data structure for use in creating a dialog box stating there are no errors in
%this section, if all code was run
CreateStruct.Interpreter = 'tex';
CreateStruct.Resize = 'on';
CreateStruct.WindowStyle = 'modal';



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 1',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end


%% SECTION 2 - Create Field Variables

%First field within data structure = data for quals versus for remainder of dissertation
QualvsPostQualData = {'Post_Quals'};
%Second field = group list
GroupList = {'ATx','Control'}; 
%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC08', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC53', 'HC44', 'HC48', 'HC65' };
%4th field = data type
DataCategories_HoppingGRFandKin = {'HoppingKinematicsKinetics'};
DataCategories_HoppingKinematicsKineticss = {'HoppingKinematicsKinetics'};
DataCategories_IndividualHops = {'IndividualHops'};
%5th field = limb ID
LimbID = {'LeftLimb','RightLimb'};
MTUID = {'GasLat_MTU','GasMed_MTU'};
%MuscleID = HoppingGRFandKin_Trial1.Properties.VariableNames;
RLimb_MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
LLimb_MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
%6th field = trial number
HoppingTrialNumber = {'Trial1'};
%6th field = Hopping Rate
HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};

%Specify sampling rates for GRF, EMG, kinematics/kinetics
GRFSampHz = 1500;
EMGSampHz = 1500;
MoCapSampHz = 300;

%Create vector of participant masses
ATxParticipantMass = [ 69.90, 64.66, 107.47, 84.35, 83.07, 68.80, 84.39, 81.96, 90.30, 79.08, 79.67, 87.51, 58.12, 61.82, 90.18, 80.99, 67.28, 70.30, 71.72, 57.66 ]; 
%ATx07, ATx08, ATx10, ATx12, ATx17, ATx18, ATx19, ATx21, ATx24, ATx25, ATx27, ATx34, ATx38, ATx41, ATx44,
%ATx50, ATx36
ControlParticipantMass = [ 57.24, 83.50, 61.37, 80.99, 105.01, 61.66, 77.14, 75.66, 79.75, 68.08, 75.28, 65.44, 82.52, 50.40, 60.45, 91.25, 60.39 ]; 
%HC01, HC05, HC06, HC08, HC11, HC12, HC17, HC19, HC20, HC21, HC25, HC42, HC45, 'HC53', HC44, HC48

%We'll eventually need to tell the code which ground reaction force data to extract from the data
%structure
GRF_IDs = {'VGRF_Downsampled','VGRF_Normalized_Downsampled'};

%We'll need to tell the code the names of the lower extremity joints. Some of the data will be
%stored separately under each joint
JointID = {'Ankle','Knee','Hip'};

%Similar to above - some of the data will be stored under Sagittal plane WITHIN each joint
PlaneID = {'Sagittal'};



%String for labeling y-axis of non-normalized EMG
s = sprintf('Voltage (%cV)', char(956));




%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end





%% SECTION 3 - For Loop for Creating Structure with List of Groups

for l = 1:numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});

 %% M For Loop - GROUP LIST
    for m = 1:numel(GroupList)
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure,GroupList{m});
        
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{m}, 'ATx' )
            
                ParticipantList = ATxParticipantList;

                ParticipantMass = ATxParticipantMass;

            
        else
            
                ParticipantList = ControlParticipantList;

                ParticipantMass = ControlParticipantMass;

            
        end
        
        
        

 %% N For Loop - PARTICIPANT LIST     
        for n = 1 : numel(ParticipantList)
            

%% Set Limb ID, Hopping Rate            
            
            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %tables, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{n}, 'ATx07'  ) || strcmp( ParticipantList{n}, 'ATx08'  ) || strcmp( ParticipantList{n}, 'ATx10'  ) || strcmp( ParticipantList{n}, 'ATx17'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx18'  ) || strcmp( ParticipantList{n}, 'ATx21'  ) || strcmp( ParticipantList{n}, 'ATx25'  ) || strcmp( ParticipantList{n}, 'ATx36'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx38'  ) || strcmp( ParticipantList{n}, 'ATx39'  ) || strcmp( ParticipantList{n}, 'ATx41'  ) || strcmp( ParticipantList{n}, 'ATx49'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx74'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx07 has 2 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx12'  ) || strcmp( ParticipantList{n}, 'ATx24'  ) || 
                
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx12 has 2 hopping rates
                HoppingRate_ID = { 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 2, 2.3 ];




            elseif strcmp( ParticipantList{n}, 'ATx19'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %ATx07 has 2 hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 2, 2.3 ];



            elseif strcmp( ParticipantList{n}, 'ATx27'  ) || strcmp( ParticipantList{n}, 'ATx34'  ) || strcmp( ParticipantList{n}, 'ATx44'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx50'  )
             
                %LimbIDs for ATx participants
                LimbID = {'InvolvedLimb','NonInvolvedLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx07 has 2 hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz' };
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ]; 
                
                



            elseif strcmp( ParticipantList{ n }, 'HC11'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.3 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 2, 2.3 ];
                
                



            elseif strcmp( ParticipantList{ n }, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'RightLimb', 'LeftLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb' };
                
                %HC42 has only the 2.0 and 2.3 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 2, 2.3 ];
                
                
                

            elseif strcmp( ParticipantList{ n }, 'HC11'  ) ||  strcmp( ParticipantList{ n }, 'HC17'  ) || strcmp( ParticipantList{ n }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ n }, 'HC32'  ) || strcmp( ParticipantList{ n }, 'HC34'  ) || strcmp( ParticipantList{ n }, 'HC45'  ) || strcmp( ParticipantList{ n }, 'HC48'  )
                
                %LimbIDs for ATx participants
                LimbID = {'LeftLimb', 'RightLimb'};
                
                %The first limb is the involved limb. Output from V3D is labeled as right or left,
                %not as involved and noninvolved. This variable will help us pull out the joint
                %level data
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %ATx10 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                HoppingRate_ID_forTable = [ 0, 2, 2.3 ];


            else
                
                %For this code, will only process the right limb
                LimbID = { 'RightLimb', 'LeftLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'RightLimb', 'LeftLimb',  };
                
                %HC01 has three hopping rates
                HoppingRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTable = [ 0, 2, 2.3 ];
                
                               
            end
            
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ n }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ n }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
            
            
            %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
            ParticipantN_DataStructure = getfield(ParticipantListDataStructure,ParticipantList{ n });
            
            %Use get field to create a new data structure containing the indexing data for
            %Participant L
            ListofVariables_IndexingInParticipantN = getfield( ParticipantN_DataStructure, 'UseforIndexingIntoData' );
            
            
            
                          
%% A FOR LOOP - LIMB ID            
            
            for a = 1 : numel(LimbID)
            
                %Use get field to create a new data structure containing the list of limbs. Stored under the 4th field of the structure (the list of data categories)
                IndividualHops_DataStructure = getfield(ParticipantN_DataStructure,'IndividualHops');
                
                
                
                %For ATx18, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle
                  if strcmp( ParticipantList{n}, 'ATx07'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx07'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                         
                     %For ATx10, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx10'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx10 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        

                    %For ATx10, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx10'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx10 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         

                     %For ATx17, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx17 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{a}, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                         
                     %For ATx18, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx18 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{a}, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                     
                        
                        
                    
                         
                         
                     %For ATx19, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                     %For ATx21, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         

                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};




                    elseif strcmp( ParticipantList{ n }, 'ATx36'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ n }, 'ATx36'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx36 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};




                    elseif strcmp( ParticipantList{ n }, 'ATx38'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ n }, 'ATx38'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx38 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ n }, 'ATx44'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ n }, 'ATx44'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ n }, 'ATx50'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ n }, 'ATx50'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx50 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};




                    %LLGas for HC53 seems questionable. Don't include in the analysis     
                    elseif strcmp( ParticipantList{n}, 'HC53'  ) && strcmp( LimbID{ a}, 'LeftLimb')

                        %Set the muscle ID list for HC53 left limb
                        MuscleID = {'LMGas','LSol','LPL','LTA'};
                         
                         
                         
                    %For the Control group, tell the code that the MuscleID should use 'R' in front
                    %of each muscle for the Right Limb
                    elseif strcmp(LimbID{a},'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the Left Limb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                     end 
                    
                    
                
                
                
                ListofLimbVariables_DataStructure = getfield(IndividualHops_DataStructure, LimbID{a} ); 
                

                %Use get field to create a new data structure containing the indexing data for
                %Limb A
                IndexingWthinLimbA_IndividualHops = getfield( ListofVariables_IndexingInParticipantN, LimbID{ a } );
                    
                
                
                
    %% B For Loop - Create Data Structure Containing List of Hopping Rates         
    
                    for b = 1 : numel( HoppingRate_ID )

                        

                        %For now, we only have one hopping trial
                        HoppingTrialNumber = {'Trial1'};

                        
                        
                        MLGRF_HoppingRates_DataStructure = getfield( ListofLimbVariables_DataStructure.ML_GRF, HoppingRate_ID{b} );
                        APGRF_HoppingRates_DataStructure = getfield( ListofLimbVariables_DataStructure.AP_GRF, HoppingRate_ID{b} );
                        VGRF_HoppingRates_DataStructure = getfield( ListofLimbVariables_DataStructure.V_GRF, HoppingRate_ID{b} );
                        
                        MLGRF_IndividualHops_Normalized = getfield(ListofLimbVariables_DataStructure.ML_GRF_Normalized, HoppingRate_ID{b} );
                        APGRF_IndividualHops_Normalized = getfield(ListofLimbVariables_DataStructure.AP_GRF_Normalized,HoppingRate_ID{b} );
                        VGRF_IndividualHops_Normalized = getfield(ListofLimbVariables_DataStructure.V_GRF_Normalized, HoppingRate_ID{b} );
                        
                        
                        
                        %Use get field to create a new data structure containing the
                         %indexing data for Hopping Rate B
                        IndexingWthinHoppingRateB = getfield( IndexingWthinLimbA_IndividualHops, HoppingRate_ID{b} );
                        
                        
                        %Length of each phase in GRF Sampling Hz
                        LengthofHopCycle_GRFSampHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_GRFSamplingHz;
                        
                        
                        
    %% Q For Loop - Run Once For Each Bout of Hopping (Each Hop = One Trial, Collection of Trials = Bout)             
                        for q = 1:numel(HoppingTrialNumber)


    %% Initialize Variables - Renew For Each Hopping Bout

                            MLGRF_IndividualHops_DownSampled = NaN(10,numel(HoppingTrialNumber));
                            MLGRF_IndividualHops_DownSampled_Normalized = NaN(10,numel(HoppingTrialNumber));
                            MLGRF_IndividualHops = getfield(MLGRF_HoppingRates_DataStructure,HoppingTrialNumber{q});


                            APGRF_IndividualHops_DownSampled = NaN(10,numel(HoppingTrialNumber));
                            APGRF_IndividualHops_DownSampled_Normalized = NaN(10,numel(HoppingTrialNumber));
                            APGRF_IndividualHops = getfield(APGRF_HoppingRates_DataStructure,HoppingTrialNumber{q});


                            VGRF_IndividualHops_DownSampled = NaN(10,numel(HoppingTrialNumber));
                            VGRF_IndividualHops_DownSampled_Normalized = NaN(10,numel(HoppingTrialNumber));
                            VGRF_IndividualHops = getfield(VGRF_HoppingRates_DataStructure,HoppingTrialNumber{q});

    %% Create Variables - GRF for One Bout of Hopping                            

                            RLimb_MLGRF_IndividualHops_Normalized = getfield(MLGRF_IndividualHops_Normalized, HoppingTrialNumber{q} );
                            RLimb_APGRF_IndividualHops_Normalized = getfield(APGRF_IndividualHops_Normalized,HoppingTrialNumber{q});
                            RLimb_VGRF_IndividualHops_Normalized = getfield(VGRF_IndividualHops_Normalized,HoppingTrialNumber{q});

                            NumEl_RthHop = NaN( numel( LengthofHopCycle_GRFSampHz ), 1);
                            NumEl_RthHop_Downsampled = NaN( numel( LengthofHopCycle_GRFSampHz ), 1);
                            NumEl_RthHopKinematics = NaN( numel( LengthofHopCycle_GRFSampHz ), 1);

                            
                            
                            
    %% Begin R For Loop - One Loop Per Hop                            

                            for r = 1 : numel( LengthofHopCycle_GRFSampHz )

                                
                               %Find the number of rows in the Qth Bout of Hopping
                               NumberofRows_GRF = size(MLGRF_IndividualHops,1); 

                               %Find the length of trial for the Rth hop and store in a new variable
                               NumEl_RthHop(r) = MLGRF_IndividualHops(NumberofRows_GRF,r);



                               %Divide the GRF sampling Hz by the MoCap sampling Hz to find the
                               %number of elements to average within a single window  of the GRF
                               %data.
                                NumberofElementstoAverageforDownSampling = GRFSampHz/MoCapSampHz;

                                %Create a number sequence using the above number of elements within
                                %a single window - spacing will be this number of elements and allow
                                %for easy stepping through the GRF data
                                NumberSequenceforDownSampling = 1:NumberofElementstoAverageforDownSampling : LengthofHopCycle_GRFSampHz(r);


                                NumEl_RthHop_Downsampled(r) = ceil( LengthofHopCycle_GRFSampHz(r) ./ NumberofElementstoAverageforDownSampling );

                                

    %% Begin S For Loop - Run Once Per Interval in NumberSequenceforDownSampling                                
                                for s = 1:numel(NumberSequenceforDownSampling)

                                    %If the Sth element is the last element in
                                    %NumberSequenceforDownSampling, tell the script to average the
                                    %elements from that data point to the end of the trial.
                                    %Otherwise, the S For loop will continue to look for the Sth + 1
                                    %data point in NumberSequenceforDownSampling - but this doesn't
                                    %exist.
                                    if s == numel(NumberSequenceforDownSampling)

                                        MLGRF_IndividualHops_DownSampled(s,r) = mean(MLGRF_IndividualHops(NumberSequenceforDownSampling(s): LengthofHopCycle_GRFSampHz(r),r));
                                        APGRF_IndividualHops_DownSampled(s,r) = mean(APGRF_IndividualHops(NumberSequenceforDownSampling(s): LengthofHopCycle_GRFSampHz(r),r));
                                        VGRF_IndividualHops_DownSampled(s,r) = mean(VGRF_IndividualHops(NumberSequenceforDownSampling(s): LengthofHopCycle_GRFSampHz(r),r));


                                        MLGRF_IndividualHops_DownSampled_Normalized(s,r) = mean(RLimb_MLGRF_IndividualHops_Normalized(NumberSequenceforDownSampling(s): LengthofHopCycle_GRFSampHz(r),r));
                                        APGRF_IndividualHops_DownSampled_Normalized(s,r) = mean(RLimb_APGRF_IndividualHops_Normalized(NumberSequenceforDownSampling(s): LengthofHopCycle_GRFSampHz(r),r));
                                        VGRF_IndividualHops_DownSampled_Normalized(s,r) = mean(RLimb_VGRF_IndividualHops_Normalized(NumberSequenceforDownSampling(s): LengthofHopCycle_GRFSampHz(r),r));


                                    %If the Sth element is NOT the last element in
                                    %NumberSequenceforDownSampling, tell the script to use the Sth and S+1st intervals in NumberSequenceforDownSampling.
                                    else

                                        MLGRF_IndividualHops_DownSampled(s,r) = mean(MLGRF_IndividualHops(NumberSequenceforDownSampling(s):(NumberSequenceforDownSampling(s+1)-1),r));
                                        APGRF_IndividualHops_DownSampled(s,r) = mean(APGRF_IndividualHops(NumberSequenceforDownSampling(s):(NumberSequenceforDownSampling(s+1)-1),r));
                                        VGRF_IndividualHops_DownSampled(s,r) = mean(VGRF_IndividualHops(NumberSequenceforDownSampling(s):(NumberSequenceforDownSampling(s+1)-1),r));

                                        MLGRF_IndividualHops_DownSampled_Normalized(s,r) = mean(RLimb_MLGRF_IndividualHops_Normalized(NumberSequenceforDownSampling(s):(NumberSequenceforDownSampling(s+1)-1),r));
                                        APGRF_IndividualHops_DownSampled_Normalized(s,r) = mean(RLimb_APGRF_IndividualHops_Normalized(NumberSequenceforDownSampling(s):(NumberSequenceforDownSampling(s+1)-1),r));
                                        VGRF_IndividualHops_DownSampled_Normalized(s,r) = mean(RLimb_VGRF_IndividualHops_Normalized(NumberSequenceforDownSampling(s):(NumberSequenceforDownSampling(s+1)-1),r));

                                    end%End If Loop within S Loop

    %% End S For Loop - One Per Interval

                                end


                                 NumEl_RthHopKinematics(r) = NumEl_RthHop_Downsampled(r);



    %% End R For Loop - One Per Hop
                            end




    %% Store M-L GRF in Data Structure

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'IndividualHops',LimbID{a},...
                                'ML_GRF_DownSampled',HoppingRate_ID{b},HoppingTrialNumber{q},MLGRF_IndividualHops_DownSampled);

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'IndividualHops',LimbID{a},...
                                'ML_GRF_DownSampled_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},MLGRF_IndividualHops_DownSampled_Normalized);
    %% Store A-P GRF in Data Structure

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'IndividualHops',LimbID{a},...
                                'AP_GRF_DownSampled',HoppingRate_ID{b},HoppingTrialNumber{q},APGRF_IndividualHops_DownSampled);

                           David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'IndividualHops',LimbID{a},...
                                'AP_GRF_DownSampled_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},APGRF_IndividualHops_DownSampled_Normalized);
    %% Store V GRF in Data Structure

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'IndividualHops',LimbID{a},...
                                'V_GRF_DownSampled',HoppingRate_ID{b},HoppingTrialNumber{q},VGRF_IndividualHops_DownSampled);

                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'IndividualHops',LimbID{a},...
                                'V_GRF_DownSampled_Normalized',HoppingRate_ID{b},HoppingTrialNumber{q},VGRF_IndividualHops_DownSampled_Normalized);

                            
                            
                            David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m},ParticipantList{n},'UseforIndexingIntoData',LimbID{a},...
                               HoppingRate_ID{b}, HoppingTrialNumber{q},'LengthofDownsampledHopCycle_GRFSampHz', NumEl_RthHop_Downsampled);
                            
                            

                        end%End Q For Loop - Hopping Trial Number
                    
                    end%End B Loop - Hopping Rate

            end%End A Loop - Limb ID
                
        end%End N Loop - Participant ID
        
    end%End M Loop - Group ID
    
end%End L Loop - Data Category





clearvars -except David_DissertationDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList DataCategories_HoppingKinematicsKinetics ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass CreateStruct

clc



if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end