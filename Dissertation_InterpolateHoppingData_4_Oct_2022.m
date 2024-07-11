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





%% SECTION 3 - Initialize Variables

RowtoFill = 1;

MaxKineticTrialLengthFromEachTrialAcrossParticipants = NaN(4,1);
MaxKineticTrialLength_EachTrial_Downsampled = NaN(4,1);
MaxKinematicTrialLengthFromEachTrialAcrossParticipants = NaN(4,1);
MaxEMGTrialLengthFromEachTrialAcrossParticipants_Downsamp = NaN(4,1);
MaxEMGTrialLengthFromEachTrialAcrossParticipants_NotDownSampled = NaN(4,1);



MaxKineticTrialLengthAcrossParticipants_ContactPhase = NaN(4,1);
MaxKinematicTrialLengthAcrossParticipants_ContactPhase = NaN(4,1);
MaxEMGTrialLengthFromEachTrialAcrossParticipants_ContactPhase = NaN(4,1);
MinEMGTrialLengthFromEachTrialAcrossParticipants_ContactPhase = NaN(4,1);
MaxEMGTrialLength_ContactPhase_NotDownSampled = NaN(4,1);



MaxKineticTrialLengthAcrossParticipants_BrakingPhase = NaN(4,1);
MaxKinematicTrialLengthAcrossParticipants_BrakingPhase = NaN(4,1);
MaxEMGTrialLengthFromEachTrialAcrossParticipants_BrakingPhase = NaN(4,1);
MaxEMGTrialLength_BrakingPhase_NotDownSampled = NaN(4,1);




MaxKineticTrialLengthAcrossParticipants_PropulsionPhase = NaN(4,1);
MaxKinematicTrialLengthAcrossParticipants_PropulsionPhase = NaN(4,1);
MaxEMGTrialLengthFromTrialAcrossParticipants_PropulsionPhase = NaN(4,1);
MaxEMGTrialLength_PropulsionPhase_NotDownSampled = NaN(4,1);





%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 4 - Find Maximum Trial Length for Each Participant

for l = 1:numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});
  
    
%% M For Loop - Run Once Per Group     
    
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
        
%% N For Loop - Run Once Per Participant        
        


        for n = 1:numel(ParticipantList)
            
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
            
            
            
            
            %Use get field to create a new data structure containing the data for Participant L
            ListofDataCategories_ParticipantN = getfield( ParticipantListDataStructure, ParticipantList{ n } );
            
            %Use get field to create a new data structure containing the individual hop data for
            %Participant L
            ListofVariables_IndividualHops = getfield( ListofDataCategories_ParticipantN, 'IndividualHops' );
            
            %Use get field to create a new data structure containing the indexing data for
            %Participant L
            ListofVariables_IndexingInParticipantN = getfield( ListofDataCategories_ParticipantN, 'UseforIndexingIntoData' );


            
            
            
            
            

%% A For Loop - Run Once Per Limb            
            
            for a = 1:numel(LimbID)
                    
                
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
                         MuscleID = {'RMGas','RLGas','RSol','RPL' };
                         
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
                
                
                    
                %Use getfield to create a new data structure containing the data for Limb A
                ListofLimbIDs_DataStructure = getfield( ListofVariables_IndividualHops, LimbID{ a } );            
            
                %Use get field to create a new data structure containing the indexing data for
                %Limb A
                IndexingWthinLimbA_IndividualHops = getfield( ListofVariables_IndexingInParticipantN, LimbID{ a } );
                
                %Use get field to create a new data structure containing the data for Medial Gastroc
                 ListofVariables_MedGas = getfield( ListofLimbIDs_DataStructure, MuscleID{ 1 } );
                            
                            
 %% B For Loop - Run Once Per Hopping Rates                           

                            
                            for b = 1 : numel(HoppingRate_ID)
                            
                                
                                
                                  %Use get field to create a new data structure containing the
                                  %medial gastroc data for Hopping Rate B
                                  ListofVariables_HoppingRateB = getfield( ListofVariables_MedGas, HoppingRate_ID{ b } );
                                 
                                 
                        
                                 %Use get field to create a new data structure containing the
                                 %indexing data for Hopping Rate B
                                IndexingWthinHoppingRateB = getfield( IndexingWthinLimbA_IndividualHops, HoppingRate_ID{b} );


                                
                                
                                %Use get field to access the normalized, downsampled EMG for the
                                 %medial gastroc - this is for the entire hop cycle
                                 MedGas_NormalizedEMG_Downsampled = getfield( ListofVariables_HoppingRateB.Trial1, 'NormalizedEMG_Downsampled' );

                                 
                                 
                                 
                                 

                                 
                                 
                                %Pull out the lengths of the entire hop cycle, contact phase, 
                                %braking phase, and propulsion phase for all hops. We will use these to tell
                                %the code how many data points to access for a given hop. Example: Hop 1 may
                                %be 10 data points but Hop 11 may be 12 data points
                                
                                    %Length of each phase in EMG Sampling Hz
                                LengthofHopCycle_EMGSampHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_EMGSamplingHz;
                                
                                %How many rows are there in MedGas_NormalizedEMG_Downsampled? Need
                                 %to know this because the length of each hop is stored in the last
                                 %row
                                 LengthofHopCycle_EMGSampHz_Downsampled = MedGas_NormalizedEMG_Downsampled( size( MedGas_NormalizedEMG_Downsampled, 1), : );
                                 
                                 %Length of contact phase - EMG sampling Hz - BEFORE downsampling
                                LengthofContactPhase_EMGSampHz = IndexingWthinHoppingRateB.LengthofContactPhase_EMGSamplingHz;

                                %Length of braking phase - EMG sampling Hz - BEFORE downsampling
                                LengthofBrakingPhase_EMGSampHz = IndexingWthinHoppingRateB.Trial1.LengthofBrakingPhase_EMGSampHz;

                                %Length of propulsion phase - EMG sampling Hz - BEFORE downsampling
                                LengthofPropulsionPhase_EMGSampHz = IndexingWthinHoppingRateB.Trial1.LengthofPropulsionPhase_EMGSampHz;
                                
                                
                                
                                
                                %Length of each phase in GRF Sampling Hz
                                LengthofHopCycle_GRFSampHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_GRFSamplingHz;
                                
                                LengthofDownsampledHopCycle_GRFSampHz = IndexingWthinHoppingRateB.Trial1.LengthofDownsampledHopCycle_GRFSampHz;

                                LengthofContactPhase_GRFSampHz = IndexingWthinHoppingRateB.LengthofContactPhase_GRFSamplingHz;
                                
                                
                                
                                
                                %Length of each phase in MoCap Sampling Hz
                                LengthofHopCycle_MoCapSampHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_MoCapSamplingHz;

                                LengthofContactPhase_MoCapSampHz = IndexingWthinHoppingRateB.LengthofContactPhase_MoCapSamplingHz;

                                LengthofBrakingPhase_MoCapSampHz = IndexingWthinHoppingRateB.Trial1.LengthofBrakingPhase_MoCapSampHz;

                                LengthofPropulsionPhase_MoCapSampHz = IndexingWthinHoppingRateB.Trial1.LengthofPropulsionPhase_MoCapSampHz;
                                
                                
                                
%                                 SAVE THIS CODE IN CASE IT'S NEEDED
%                                 %Use getfield to create a new data structure containing the data for
%                                 %Hopping Rate B
%                                 LimbA_Torque_HoppingRateB = getfield(LimbA_PlaneQ.Torque, HoppingRate_ID{b} );
%                                 
%                                 %Use getfield to create a new data structure containing the data for
%                                 %the Medial Gastroc
%                                 GasMed_HoppingRates = getfield(ListofMTUVariables_DataStructure, MuscleID{1} );
%                                 
%                                 
%                                 %Create separate data structure containing the medial gastroc EMG
%                                 %data for Hopping Rate B
%                                 GasMed_EMG = getfield(GasMed_HoppingRates, HoppingRate_ID{b} );
%                                 
%                                 
%                                 %Create separate data structure containing the vGRF data for the rth trial of
%                                     %hopping
%                                 LimbA_VGRF_HoppingRateB = getfield(ListofMTUVariables_DataStructure.V_GRF_DownSampled_Normalized, HoppingRate_ID{b} );
%                                 
%                                 
%                                 LimbA_ContactPhaseTorque_HoppingRateB = getfield(LimbA_PlaneQ.Torque_ContactPhase, HoppingRate_ID{b} );
                                
                                



 %% Trial Lengths for Entire Hop Cycle                                   
                                   
                                %Find the maximum length of the hops in a given trial, in GRF
                                %sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in. This is the
                                %non-downsampled data
                                MaxKineticTrialLengthFromEachTrialAcrossParticipants(RowtoFill) = max( LengthofHopCycle_GRFSampHz );
                                
                                %Length of GRF data for DOWNSAMPLED data
                                MaxKineticTrialLength_EachTrial_Downsampled( RowtoFill ) = max( LengthofDownsampledHopCycle_GRFSampHz );
                                
                                

                                %Find the maximum length of the hops in a given trial, in MoCap sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                MaxKinematicTrialLengthFromEachTrialAcrossParticipants(RowtoFill) = max( LengthofHopCycle_MoCapSampHz );



                                %Find the maximum length of the  hops in a given trial, in EMG sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                
                                    %Max length of EMG trials AFTER they were downsampled to match
                                    %kinematics
                                MaxEMGTrialLengthFromEachTrialAcrossParticipants_Downsamp(RowtoFill) = max( LengthofHopCycle_EMGSampHz_Downsampled );

                                    %Max length of EMG trials BEFORE they were downsampled to match
                                    %kinematics
                                MaxEMGTrialLengthFromEachTrialAcrossParticipants_NotDownSampled(RowtoFill) = max( LengthofHopCycle_EMGSampHz );


                                
                                

        %% Trial Lengths for Contact Phase Only                            


                                %Find the maximum length of the hops in a given trial, in GRF
                                %sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in. BEFORE
                                %downsampling
                                MaxKineticTrialLengthAcrossParticipants_ContactPhase(RowtoFill) = max( LengthofContactPhase_GRFSampHz );

                                %Find the maximum length of the hops in a given trial, in MoCap sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                MaxKinematicTrialLengthAcrossParticipants_ContactPhase(RowtoFill) = max( LengthofContactPhase_MoCapSampHz );



                                %Find the maximum length of the  hops in a given trial, in EMG sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                
                                    %Max contact phase length of EMG trials BEFORE they were downsampled to match
                                    %kinematics
                                MaxEMGTrialLengthFromEachTrialAcrossParticipants_ContactPhase(RowtoFill) = max( LengthofContactPhase_EMGSampHz );

                                
                                %Find minimum EMG trial length
                                MinEMGTrialLengthFromEachTrialAcrossParticipants_ContactPhase(RowtoFill) = min( LengthofContactPhase_EMGSampHz );
                                
                                
        %% Trial Lengths for Braking Phase Only                            




                                %Find the maximum length of the hops in a given trial, in MoCap sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                MaxKinematicTrialLengthAcrossParticipants_BrakingPhase(RowtoFill) = max( LengthofBrakingPhase_MoCapSampHz );



                                %Find the maximum length of the  hops in a given trial, in EMG sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                
                                    %Max length of EMG trials BEFORE they were downsampled to match
                                    %kinematics
                                MaxEMGTrialLengthFromEachTrialAcrossParticipants_BrakingPhase(RowtoFill) = max( LengthofBrakingPhase_EMGSampHz );                                
                                
                                
                                


                                    
                            
                                    
                                    
         %% Trial Lengths for Propulsion Phase Only                            




                                %Find the maximum length of the hops in a given trial, in MoCap sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                MaxKinematicTrialLengthAcrossParticipants_PropulsionPhase(RowtoFill) = max( LengthofPropulsionPhase_MoCapSampHz );



                                %Find the maximum length of the  hops in a given trial, in EMG sampling Hz. RowtoFill tells the
                                %loop which row to store the max trial length in.
                                
                                    %Max length of EMG trials BEFORE they were downsampled to match
                                    %kinematics
                                MaxEMGTrialLengthFromTrialAcrossParticipants_PropulsionPhase(RowtoFill) = max( LengthofPropulsionPhase_EMGSampHz );                                   
                                    
                                    
                            %Add one to RowtoFill so next loop will store max trial length in a new row
                                    RowtoFill = RowtoFill + 1;
                            
                                    
                                    
                            end%End B Loop - Hopping Rate

            end%End For Loop - Limb ID

        end%End For Loop - Participant List
            
    end%End For Loop - Group List
        
end


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end












%% SECTION 5 - Find Max Kinematic Trial Length Across ALL Participants

%Find the maximum kinematic, kinetic, and EMG trial lengths across all participants - entire hop
%cycle
MaxKinematicTrialLengthAcrossParticipants = max(MaxKinematicTrialLengthFromEachTrialAcrossParticipants);
MaxKineticTrialLengthAcrossParticipants = max( MaxKineticTrialLength_EachTrial_Downsampled );
MaxEMGTrialLengthAcrossParticipants = max( MaxEMGTrialLengthFromEachTrialAcrossParticipants_Downsamp );

%Find the maximum trial length ACROSS the kinematic, kinetic, or EMG trials - entire hop cycle
MaxTrialLengthAcrossParticipants = max([MaxKinematicTrialLengthAcrossParticipants, MaxKineticTrialLengthAcrossParticipants, ...
    MaxEMGTrialLengthAcrossParticipants]);


%Find the maximum kinematic, kinetic, and EMG trial lengths across all participants - contact phase
MaxKineticTrialLengthAcrossParticipants_ContactPhase = max( MaxKineticTrialLengthAcrossParticipants_ContactPhase ); %BEFORE downsampling
MaxKinematicTrialLengthAcrossParticipants_ContactPhase = max( MaxKinematicTrialLengthAcrossParticipants_ContactPhase ); %BEFORE downsampling
MaxEMGTrialLengthAcrossParticipants_ContactPhase = max( MaxEMGTrialLengthFromEachTrialAcrossParticipants_ContactPhase  ); %BEFORE downsampling


%Find the maximum trial length ACROSS the kinematic, kinetic, or EMG trials - contact phase. BEFORE
%downsampling
MaxTrialLengthAcrossParticipants_ContactPhase = max([MaxKinematicTrialLengthAcrossParticipants_ContactPhase, MaxKineticTrialLengthAcrossParticipants_ContactPhase, ...
    MaxEMGTrialLengthAcrossParticipants_ContactPhase] );






%Find the maximum kinematic, kinetic, and EMG trial lengths across all participants - braking phase
MaxKineticTrialLengthAcrossParticipants_BrakingPhase = max(MaxKineticTrialLengthAcrossParticipants_BrakingPhase);
MaxKinematicTrialLengthAcrossParticipants_BrakingPhase = max(MaxKinematicTrialLengthAcrossParticipants_BrakingPhase);
MaxEMGTrialLengthAcrossParticipants_BrakingPhase = max( MaxEMGTrialLengthFromEachTrialAcrossParticipants_BrakingPhase  );


%Find the maximum trial length ACROSS the kinematic, kinetic, or EMG trials - braking phase
MaxTrialLengthAcrossParticipants_BrakingPhase = max([MaxKinematicTrialLengthAcrossParticipants_BrakingPhase, ...
    MaxEMGTrialLengthAcrossParticipants_BrakingPhase] );




%Find the maximum kinematic, kinetic, and EMG trial lengths across all participants - propulsion
%phase
MaxKineticTrialLengthAcrossParticipants_PropulsionPhase = max(MaxKineticTrialLengthAcrossParticipants_PropulsionPhase);
MaxKinematicTrialLengthAcrossParticipants_PropulsionPhase = max(MaxKinematicTrialLengthAcrossParticipants_PropulsionPhase);
MaxEMGTrialLengthAcrossParticipants_PropulsionPhase = max( MaxEMGTrialLengthFromTrialAcrossParticipants_PropulsionPhase  );

%Find the maximum trial length ACROSS the kinematic, kinetic, or EMG trials - propulsion phase
MaxTrialLengthAcrossParticipants_PropulsionPhase = max([MaxKinematicTrialLengthAcrossParticipants_PropulsionPhase, ...
    MaxEMGTrialLengthAcrossParticipants_PropulsionPhase] );



%Find the maximum trial length for the EMG data BEFORE downsampling. This is for the entire hop
%cycle
MaxEMGTrialLengthAcrossParticipants_NotDownsampled = max( MaxEMGTrialLengthFromEachTrialAcrossParticipants_NotDownSampled );



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 5',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end









%% SECTION 6 - Initialize Variables To Be Used in the Interpolation Section


%These matrices store the absolute and normalized vGRF values for only one trial of hopping
DownsampledVGRF_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);
DownsampledNormalizedVGRF_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the absolute and normalized vGRF values for all hops from all
%given participants. One column per participant
DownsampledVGRF_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);
DownsampledNormalizedVGRF_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);



%These matrices store the joint angle values for only one trial of hopping
Angle_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the joint angle values for all hops from all
%given participants. One column per participant
Angle_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);

%These matrices store the joint torque values for only one trial of hopping
Torque_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the joint torque values for all hops from all
%given participants. One column per participant
Torque_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);

%These matrices store the joint power values for only one trial of hopping
Power_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the joint power values for all hops from all
%given participants. One column per participant
Power_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);










%These matrices store the joint angle values for only one trial of hopping
Angle_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,10);

%These matrices store the average of the joint angle values for all hops from all
%given participants. One column per participant
Angle_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the joint torque values for only one trial of hopping
Torque_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,10);

%These matrices store the average of the joint torque values for all hops from all
%given participants. One column per participant
Torque_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the joint power values for only one trial of hopping
Power_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,10);

%These matrices store the average of the joint power values for all hops from all
%given participants. One column per participant
Power_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%This matrix stores the joint work values for each individual hop, during the contact phaseonly
Work_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,10);

%This matrix stores the average of the joint work values for all hops from all
%given participants. One column per participant
Work_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1 );






%Initialize EMG Variables - Rectified EMG

    %%% Rectified, Downsampled EMG
GasMed_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

GasLat_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

Sol_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

PL_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

TA_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );






%%% Normalized, Downsampled EMG 
GasMed_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

GasLat_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

Sol_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

PL_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

TA_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );











%%% Rectified EMG - Not Downsampled
GasMed_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

GasLat_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

Sol_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

PL_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

TA_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );








%%% Normalized, Not Downsampled EMG 
GasMed_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

GasLat_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

Sol_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

PL_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

TA_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );






%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 6',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end










%% SECTION 7 - INTERPOLATE Data

for l = 1 : numel( QualvsPostQualData )
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});

%% M Loop - Run Once Per Group   
    
    for m = 1 : numel(GroupList)
        
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
        
        
%These matrices store the absolute and normalized vGRF values for only one trial of hopping
DownsampledVGRF_Interpolated = NaN(MaxTrialLengthAcrossParticipants,1);
DownsampledNormalizedVGRF_Interpolated = NaN(MaxTrialLengthAcrossParticipants,1);

%These matrices store the average of the absolute and normalized vGRF values for all hops from all
%given participants. One column per participant
DownsampledVGRF_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);
DownsampledNormalizedVGRF_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);



%These matrices store the joint angle values for only one trial of hopping
Angle_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the joint angle values for all hops from all
%given participants. One column per participant
Angle_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);

%These matrices store the joint torque values for only one trial of hopping
Torque_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the joint torque values for all hops from all
%given participants. One column per participant
Torque_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);

%These matrices store the joint power values for only one trial of hopping
Power_Interpolated = NaN(MaxTrialLengthAcrossParticipants,10);

%These matrices store the average of the joint power values for all hops from all
%given participants. One column per participant
Power_MeanInterpolatedFromEachParticipant = NaN(MaxTrialLengthAcrossParticipants,1);










%These matrices store the joint angle values for only one trial of hopping
Angle_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the average of the joint angle values for all hops from all
%given participants. One column per participant
Angle_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the joint torque values for only one trial of hopping
Torque_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the average of the joint torque values for all hops from all
%given participants. One column per participant
Torque_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the joint power values for only one trial of hopping
Power_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%These matrices store the average of the joint power values for all hops from all
%given participants. One column per participant
Power_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%This matrix stores the joint work values for each individual hop, during the contact phaseonly
Work_ContactPhase_Interpolated = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1);

%This matrix stores the average of the joint work values for all hops from all
%given participants. One column per participant
Work_ContactPhase_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,1 );






%Initialize EMG Variables - Rectified EMG

    %%% Rectified, Downsampled EMG
GasMed_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

GasLat_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

Sol_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

PL_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

TA_RectifiedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );






%%% Normalized, Downsampled EMG 
GasMed_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

GasLat_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

Sol_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

PL_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );

TA_NormalizedEMG_MeanInterpolatedFromEachParticipant = NaN(MaxKinematicTrialLengthAcrossParticipants,1 );






%%% Rectified EMG - Not Downsampled
GasMed_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

GasLat_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

Sol_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

PL_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

TA_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );




%%% Normalized, Not Downsampled EMG 
GasMed_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

GasLat_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

Sol_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

PL_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );

TA_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt = NaN( MaxEMGTrialLengthAcrossParticipants_NotDownsampled,1 );






%Will use this when concatenating the data from each participant. Will tell the code which column to
%fill
ColumntoFill = 1;

        
   

        
%% N For Loop - Run Once Per Participant
 
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
            
            
            
            
            %Use get field to create a new data structure containing the data for Participant L
            ListofDataCategories_ParticipantN = getfield( ParticipantListDataStructure, ParticipantList{ n } );
            
            %Use get field to create a new data structure containing the individual hop data for
            %Participant L
            ListofVariables_IndividualHops = getfield( ListofDataCategories_ParticipantN, 'IndividualHops' );
            
            %Use get field to create a new data structure containing the indexing data for
            %Participant L
            ListofVariables_IndexingInParticipantN = getfield( ListofDataCategories_ParticipantN, 'UseforIndexingIntoData' );
            
            
            
            
            


            
        
%% A For Loop - Run Once Per Limb
            for a = 1 : numel(LimbID)
        
                

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
                         MuscleID = {'RMGas','RLGas','RSol','RPL' };
                         
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
                
                
                    
                %Use getfield to create a new data structure containing the data for Limb A
                ListofLimbIDs_DataStructure = getfield( ListofVariables_IndividualHops, LimbID{ a } );            
            
                %Use get field to create a new data structure containing the indexing data for
                %Limb A
                IndexingWthinLimbA_IndividualHops = getfield( ListofVariables_IndexingInParticipantN, LimbID{ a } );

                
                %Use get field to create a new data structure containing the data for Medial Gastroc
                 ListofVariables_MedGas = getfield( ListofLimbIDs_DataStructure, MuscleID{ 1 } );      
                       
                 
                 
                


%% P For Loop - Run Once Per Joint

                    for p = 1 : numel(JointID)

                        LimbA_JointP = getfield( ListofLimbIDs_DataStructure, JointID{p} );
                        %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});

                        
%% Q For Loop - Run Once Per Plane of Motion

                        %Create separate data structure containing the data for the qth plane
                            %(sagittal, frontal, or axial)
                        for q = 1 : numel(PlaneID)

                            
                            
                            
%% Initialize variables to hold the interpolated data from a given plane of motion.

                            Angle_Interpolated_AllTrialsFromParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7); 
                            Torque_Interpolated_AllTrialsFromParticipantN = NaN(MaxTrialLengthAcrossParticipants,7);
                            Power_Interpolated_AllTrialsFromParticipantN = NaN(MaxTrialLengthAcrossParticipants,7);
                            RMEE_Interpolated_AllTrialsFromParticipantN = NaN(MaxTrialLengthAcrossParticipants,7);

                            Angle_ContactPhase_Interpolated_AllTrialsFromParticipantN = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,7); 
                            Torque_ContactPhase_Interpolated_AllTrialsFromParticipantN = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,7);
                            Power_ContactPhase_Interpolated_AllTrialsFromParticipantN = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,7);
                            Work_ContactPhase_Interpolated_AllTrialsFromParticipantN = NaN(MaxKinematicTrialLengthAcrossParticipants_ContactPhase,7);


                            DownsampledVGRF_Interpolated_AllTrialsFromParticipantN = NaN(MaxTrialLengthAcrossParticipants,7);
                            NormalizedVGRF_Interpolated_AllTrialsFromParticipantN = NaN(MaxTrialLengthAcrossParticipants,7);

                            
                            DownsampledVGRF_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledNormalizedVGRF_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            
                            DownsampledRectifiedEMG_MedGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledRectifiedEMG_LatGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledRectifiedEMG_Sol_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledRectifiedEMG_PL_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledRectifiedEMG_TA_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);

                            DownsampledNormalizedEMG_MedGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledNormalizedEMG_LatGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledNormalizedEMG_Sol_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledNormalizedEMG_PL_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);
                            DownsampledNormalizedEMG_TA_Interpolated = NaN(MaxTrialLengthAcrossParticipants,7);



                            DownsampledRectifiedEMG_MedGas_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled,7);
                            DownsampledRectifiedEMG_LatGas_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled,7);
                            DownsampledRectifiedEMG_Sol_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled,7);
                            DownsampledRectifiedEMG_PL_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled,7);
                            DownsampledRectifiedEMG_TA_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled,7);

                            DownsampledNormalizedEMG_MedGas_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            DownsampledNormalizedEMG_LatGas_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            DownsampledNormalizedEMG_Sol_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            DownsampledNormalizedEMG_PL_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            DownsampledNormalizedEMG_TA_Interpolated_OriginalLength = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            
                            
                            RectifiedEMG_MedGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            RectifiedEMG_LatGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            RectifiedEMG_Sol_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            RectifiedEMG_PL_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            RectifiedEMG_TA_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            
                            
                            
                            
                            NormalizedEMG_MedGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            NormalizedEMG_LatGas_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            NormalizedEMG_Sol_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            NormalizedEMG_PL_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            NormalizedEMG_TA_Interpolated = NaN(MaxTrialLengthAcrossParticipants, 7);
                            
                            
                            
                            MedGasEMG_Rectified_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            LatGasEMG_Rectified_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            SolEMG_Rectified_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            PLEMG_Rectified_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            TAEMG_Rectified_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);

                            MedGasEMG_Normalized_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                           LatGasEMG_Normalized_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            SolEMG_Normalized_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            PLEMG_Normalized_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);
                            TAEMG_Normalized_Interpolated_ParticipantN = NaN(MaxEMGTrialLengthAcrossParticipants_NotDownsampled, 7);

                            
                            
                            MedGasEMG_Rectified_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            LatGasEMG_Rectified_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            SolEMG_Rectified_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            PLEMG_Rectified_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            TAEMG_Rectified_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);

                            MedGasEMG_Normalized_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            LatGasEMG_Normalized_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            SolEMG_Normalized_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            PLEMG_Normalized_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            TAEMG_Normalized_Downsampled_Interpolated_ParticipantN = NaN(MaxTrialLengthAcrossParticipants, 7);
                            
                            
                            
                            %Initialize the variables to hold the interpolated data FOR COHERENCE
                             
                                    %Contact phase
                            MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_ContactPhase, 7);
                            LatGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_ContactPhase, 7);
                            SolEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_ContactPhase, 7);
                            PLEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_ContactPhase, 7);
                            TAEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_ContactPhase, 7);
                            
                            
                                    %Braking phase
                            MedGasEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_BrakingPhase, 7);
                            LatGasEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_BrakingPhase, 7);
                            SolEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_BrakingPhase, 7);
                            PLEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_BrakingPhase, 7);
                            TAEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_BrakingPhase, 7);
                            
                            
                            
                                    %Propulsion phase
                            MedGasEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_PropulsionPhase, 7);
                            LatGasEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_PropulsionPhase, 7);
                            SolEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_PropulsionPhase, 7);
                            PLEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_PropulsionPhase, 7);
                            TAEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN = NaN( MaxTrialLengthAcrossParticipants_PropulsionPhase, 7);                            
                            
                            

                            %Create separate data structure containing the data for the right limb
                            LimbA_PlaneQ = getfield(LimbA_JointP, PlaneID{q} );

                            


                            
                            
                            
 %% B For Loop - Run Once Per Hopping Rate                           
                            for b = 1 : numel(HoppingRate_ID)
                            
                                %Use get field to create a new data structure containing the
                                 %indexing data for Hopping Rate B
                                IndexingWthinHoppingRateB = getfield( IndexingWthinLimbA_IndividualHops, HoppingRate_ID{b} );
                              
                                %May not need this
%                                 LimbA_ContactPhaseTorque_HoppingTrialR = getfield(LimbA_PlaneQ.Torque_ContactPhase, HoppingRate_ID{b} );
                                 
                                 
                                
                                
                                
                                    %Create variables containing the joint angle/torque/power and vGRF data
                                    %from the rth trial of hops
                                    LimbA_Angle_HoppingRateB = getfield(LimbA_PlaneQ.Angle, HoppingRate_ID{b});
                                    LimbA_Torque_HoppingRateB = getfield(LimbA_PlaneQ.Torque, HoppingRate_ID{b});
                                    LimbA_Power_HoppingRateB = getfield(LimbA_PlaneQ.Power, HoppingRate_ID{b});


                                    LimbA_Angle_ContactPhase_HoppingRateB = getfield(LimbA_PlaneQ.Angle_ContactPhase,HoppingRate_ID{b});
                                    LimbA_Torque_ContactPhase_HoppingRateB = getfield(LimbA_PlaneQ.Torque_ContactPhase,HoppingRate_ID{b});
                                    LimbA_Power_ContactPhase_HoppingRateB = getfield(LimbA_PlaneQ.Power_ContactPhase,HoppingRate_ID{b});
                                    LimbA_Work_ContactPhase_HoppingRateB = getfield(LimbA_PlaneQ.Work_EntireContactPhase,HoppingRate_ID{b});

                                    LimbA_VGRFdownsamp_HoppingRateB = getfield( ListofLimbIDs_DataStructure.V_GRF_DownSampled, HoppingRate_ID{b});
                                    LimbA_VGRFdownsamp_Normalized_HoppingRateB = getfield( ListofLimbIDs_DataStructure.V_GRF_DownSampled_Normalized, HoppingRate_ID{b});

                                    %Create variables containing the data structure for each muscle
                                    %Will contain individual data structure each for trial

                                    
                                    GasMed_EMG = getfield( ListofLimbIDs_DataStructure, MuscleID{1} );
                                    GasLat_EMG = getfield( ListofLimbIDs_DataStructure, MuscleID{2} );
                                    Sol_EMG = getfield( ListofLimbIDs_DataStructure, MuscleID{3} );
                                    PL_EMG = getfield( ListofLimbIDs_DataStructure, MuscleID{4} );
                                    TA_EMG = getfield( ListofLimbIDs_DataStructure, MuscleID{5} );
                                    
                                    

                                    MedGastroc_HoppingRateB = getfield(GasMed_EMG, HoppingRate_ID{b});
                                    LatGastroc_HoppingRateB = getfield(GasLat_EMG, HoppingRate_ID{b});
                                    Sol_HoppingRateB = getfield(Sol_EMG, HoppingRate_ID{b});
                                    PL_HoppingRateB = getfield(PL_EMG, HoppingRate_ID{b});
                                    TA_HoppingRateB = getfield(TA_EMG, HoppingRate_ID{b});
           
                                 
                                 
                                 
                                %For now, we only have one hopping trial 
                                HoppingTrialNumber = {'Trial1'};

                            
                                
                                
                                
    %% R For Loop - Run Once Per Hopping Bout

                                %Create separate data structure containing the data for the rth trial of
                                    %hopping
                                for r = 1 : numel(HoppingTrialNumber)

                                    
                                    %Create variables containing the joint angle/torque/power and vGRF data
                                    %from the rth trial of hops
                                    LimbA_Angle_HoppingTrialR = getfield(LimbA_Angle_HoppingRateB, HoppingTrialNumber{r});
                                    LimbA_Torque_HoppingTrialR = getfield(LimbA_Torque_HoppingRateB, HoppingTrialNumber{r});
                                    LimbA_Power_HoppingTrialR = getfield(LimbA_Power_HoppingRateB, HoppingTrialNumber{r});


                                    LimbA_Angle_ContactPhase_HoppingTrialR = getfield(LimbA_Angle_ContactPhase_HoppingRateB,HoppingTrialNumber{r});
                                    LimbA_Torque_ContactPhase_HoppingTrialR = getfield(LimbA_Torque_ContactPhase_HoppingRateB,HoppingTrialNumber{r});
                                    LimbA_Power_ContactPhase_HoppingTrialR = getfield(LimbA_Power_ContactPhase_HoppingRateB,HoppingTrialNumber{r});
                                    LimbA_Work_ContactPhase_HoppingTrialR = getfield(LimbA_Work_ContactPhase_HoppingRateB,HoppingTrialNumber{r});

                                    LimbA_VGRFdownsamp_HoppingTrialR = getfield(LimbA_VGRFdownsamp_HoppingRateB,HoppingTrialNumber{r});
                                    LimbA_VGRFdownsamp_Normalized_HoppingTrialR = getfield(LimbA_VGRFdownsamp_Normalized_HoppingRateB,HoppingTrialNumber{r});

                                    %Create variables containing the data structure for each muscle
                                    %Will contain individual data structure each for trial


                                    
                                    
                                    MedGastroc_HoppingTrialR = getfield(MedGastroc_HoppingRateB, HoppingTrialNumber{r});
                                    LatGastroc_HoppingTrialR = getfield(LatGastroc_HoppingRateB, HoppingTrialNumber{r});
                                    Sol_HoppingTrialR = getfield(Sol_HoppingRateB, HoppingTrialNumber{r});
                                    PL_HoppingTrialR = getfield(PL_HoppingRateB, HoppingTrialNumber{r});
                                    TA_HoppingTrialR = getfield(TA_HoppingRateB, HoppingTrialNumber{r});



                                    %Each trial contains all the EMG data - find the rectified/normalized and
                                    %downsampled EMG. Downsampled to match kinematic data
                                    MGas_Rectified_DownsampledEMG_HoppingTrialR = MedGastroc_HoppingTrialR.RectifiedEMG_Downsampled;
                                    LGas_Rectified_DownsampledEMG_HoppingTrialR = LatGastroc_HoppingTrialR.RectifiedEMG_Downsampled;
                                    Sol_Rectified_DownsampledEMG_HoppingTrialR = Sol_HoppingTrialR.RectifiedEMG_Downsampled;
                                    PL_Rectified_DownsampledEMG_HoppingTrialR = PL_HoppingTrialR.RectifiedEMG_Downsampled;
                                    TA_Rectified_DownsampledEMG_HoppingTrialR = TA_HoppingTrialR.RectifiedEMG_Downsampled;

                                    MGas_Normalized_DownsampledEMG_HoppingTrialR = MedGastroc_HoppingTrialR.NormalizedEMG_Downsampled;
                                    LGas_Normalized_DownsampledEMG_HoppingTrialR = LatGastroc_HoppingTrialR.NormalizedEMG_Downsampled;
                                    Sol_Normalized_DownsampledEMG_HoppingTrialR = Sol_HoppingTrialR.NormalizedEMG_Downsampled;
                                    PL_Normalized_DownsampledEMG_HoppingTrialR = PL_HoppingTrialR.NormalizedEMG_Downsampled;
                                    TA_Normalized_DownsampledEMG_HoppingTrialR = TA_HoppingTrialR.NormalizedEMG_Downsampled;



                                    %Each trial contains all the EMG data - find the
                                    %rectified/normalized EMG
                                    %BEFORE downsampling.
                                    MGas_Rectified_HoppingTrialR = MedGastroc_HoppingTrialR.RectifiedEMG;
                                    LGas_Rectified_HoppingTrialR = LatGastroc_HoppingTrialR.RectifiedEMG;
                                    Sol_Rectified_HoppingTrialR = Sol_HoppingTrialR.RectifiedEMG;
                                    PL_Rectified_HoppingTrialR = PL_HoppingTrialR.RectifiedEMG;
                                    TA_Rectified_HoppingTrialR = TA_HoppingTrialR.RectifiedEMG;

                                    MGas_Normalized_HoppingTrialR = MedGastroc_HoppingTrialR.NormalizedEMG;
                                    LGas_Normalized_HoppingTrialR = LatGastroc_HoppingTrialR.NormalizedEMG;
                                    Sol_Normalized_HoppingTrialR = Sol_HoppingTrialR.NormalizedEMG;
                                    PL_Normalized_HoppingTrialR = PL_HoppingTrialR.NormalizedEMG;
                                    TA_Normalized_HoppingTrialR = TA_HoppingTrialR.NormalizedEMG;

                                    
                                    
                                    %Each trial contains all the EMG data - find the rectified EMG
                                    %FOR COHERENCE
                                    
                                            %CONTACT Phase
                                    MedGas_RectifiedforCohere_Contact_HoppingTrialR = MedGastroc_HoppingTrialR.RectifiedEMG_ContactPhase_forCoherence;
                                    LatGas_RectifiedforCohere_Contact_HoppingTrialR = LatGastroc_HoppingTrialR.RectifiedEMG_ContactPhase_forCoherence;
                                    Sol_RectifiedforCohere_Contact_HoppingTrialR = Sol_HoppingTrialR.RectifiedEMG_ContactPhase_forCoherence;
                                    PL_RectifiedforCohere_Contact_HoppingTrialR = PL_HoppingTrialR.RectifiedEMG_ContactPhase_forCoherence;
                                    TA_RectifiedforCohere_Contact_HoppingTrialR = TA_HoppingTrialR.RectifiedEMG_ContactPhase_forCoherence;
                                    

                                    %Split EMG up into absorption and generation phases.
                                    MedGas_RectifiedforCohere_Braking_HoppingTrialR = MedGastroc_HoppingTrialR.RectifiedEMG_BrakingPhase_forCoherence;
                                    LatGas_RectifiedforCohere_Braking_HoppingTrialR = LatGastroc_HoppingTrialR.RectifiedEMG_BrakingPhase_forCoherence;
                                    Sol_RectifiedforCohere_Braking_HoppingTrialR = Sol_HoppingTrialR.RectifiedEMG_BrakingPhase_forCoherence;
                                    PL_RectifiedforCohere_Braking_HoppingTrialR = PL_HoppingTrialR.RectifiedEMG_BrakingPhase_forCoherence;
                                    TA_RectifiedforCohere_Braking_HoppingTrialR = TA_HoppingTrialR.RectifiedEMG_BrakingPhase_forCoherence;

                                    MedGas_RectifiedforCohere_Propulsion_HoppingTrialR = MedGastroc_HoppingTrialR.RectifiedEMG_PropulsionPhase_forCoherence;
                                    LatGas_RectifiedforCohere_Propulsion_HoppingTrialR = LatGastroc_HoppingTrialR.RectifiedEMG_PropulsionPhase_forCoherence;
                                    Sol_RectifiedforCohere_Propulsion_HoppingTrialR = Sol_HoppingTrialR.RectifiedEMG_PropulsionPhase_forCoherence;
                                    PL_RectifiedforCohere_Propulsion_HoppingTrialR = PL_HoppingTrialR.RectifiedEMG_PropulsionPhase_forCoherence;
                                    TA_RectifiedforCohere_Propulsion_HoppingTrialR = TA_HoppingTrialR.RectifiedEMG_PropulsionPhase_forCoherence;
                                    
                                    

                                    %Find the number of rows of the kinematic, EMG, kinetic data
                                    %How many rows are there in MedGas_NormalizedEMG_Downsampled? Need
                                     %to know this because the length of each hop is stored in the last
                                     %row
                                     LengthofHopCycle_EMGSampHz_Downsampled = MGas_Normalized_DownsampledEMG_HoppingTrialR( size( MGas_Normalized_DownsampledEMG_HoppingTrialR, 1), : );
                                 
                                 

                                 
                                 
                                %Pull out the lengths of the entire hop cycle, contact phase, 
                                %braking phase, and propulsion phase for all hops. We will use these to tell
                                %the code how many data points to access for a given hop. Example: Hop 1 may
                                %be 10 data points but Hop 11 may be 12 data points
                                
                                    %Length of each phase in EMG Sampling Hz
                                LengthofHopCycle_EMGSampHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_EMGSamplingHz;

                                LengthofContactPhase_EMGSampHz = IndexingWthinHoppingRateB.LengthofContactPhase_EMGSamplingHz;
                                
                                LengthofBrakingPhase_EMGSampHz = IndexingWthinHoppingRateB.LengthofBrakingPhase_EMGSampHz;
                                
                                LengthofPropulsionPhase_EMGSampHz = IndexingWthinHoppingRateB.LengthofPropulsionPhase_EMGSampHz;
                                
                                
                                
                                
                                %Length of each phase in GRF Sampling Hz
                                LengthofDownsampledHopCycle_GRFSampHz = IndexingWthinHoppingRateB.Trial1.LengthofDownsampledHopCycle_GRFSampHz;

                                LengthofContactPhase_GRFSampHz = IndexingWthinHoppingRateB.LengthofContactPhase_GRFSamplingHz;
                                

                                
                                %Length of each phase in MoCap Sampling Hz
                                LengthofHopCycle_MoCapSampHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_MoCapSamplingHz;

                                LengthofContactPhase_MoCapSampHz = IndexingWthinHoppingRateB.LengthofContactPhase_MoCapSamplingHz;
                                

                                %Find the length of the work time series
                                LengthofWorkData_MoCapSampHz = LengthofContactPhase_MoCapSampHz - 1;

                                
                                
                                
                                    
                                    
    %% S For Loop - Run Once Per Hop

                                    %Run loop once for each hop within the rth trial of hops
                                    for s = 1 : numel( LengthofHopCycle_MoCapSampHz ) 



                                        
                                        %Create a vector of time points that has a length equal to the
                                        %kinematic and kinetic data length of the sth trial. Will be used for
                                        %interpolation - tells the interpolation function that the current trial spans from 0 to 100% of the hop cycle, with a certain number of data points. 
                                        HopCycleNormalizedTime_Kinetics_SthTrialLength = linspace(0,100, LengthofDownsampledHopCycle_GRFSampHz( s ) );
                                        
                                        HopCycleNormalizedTime_Kinematics_SthTrialLength = linspace(0,100, LengthofHopCycle_MoCapSampHz( s ) - 1 );
                                        
                                        HopCycleNormalizedTime_ContactPhaseKinematics_SthTrialLength = linspace(0,100, LengthofContactPhase_MoCapSampHz(s) - 1 );
                                        
                                        HopCycleNormalizedTime_EMG_SthTrialLength = linspace(0,100, LengthofHopCycle_EMGSampHz_Downsampled( s ) );
                                        
                                        HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength = linspace(0,100, LengthofHopCycle_EMGSampHz( s )  );
                                        
                                        HopCycleNormalizedTime_ContactPhaseWork_SthTrialLength = linspace(0, 100, LengthofWorkData_MoCapSampHz( s) );

                                        HopCycleNormalizedTime_ContactPhaseEMG_SthTrialLength = linspace(0,100, LengthofContactPhase_EMGSampHz(s)  );
                                        
                                        HopCycleNormalizedTime_BrakingPhaseEMG_SthTrialLength = linspace(0,100, LengthofBrakingPhase_EMGSampHz(s)  );
                                        
                                        HopCycleNormalizedTime_PropulsionPhaseEMG_SthTrialLength = linspace(0,100, LengthofPropulsionPhase_EMGSampHz(s)  );
                                        
                                        
                                        
                                        
                                        %Create a vector of time points that has a length equal to the
                                        %maximum kinematic and kinetic data length of all participants. Will be used for
                                        %interpolation - tells the interpolation function that we want the interpolated data to span from 0 to 100% of the hop cycle, with the number of data points equal 
                                        % to the max trial length.
                                        HopCycleNormalizedTime_Kinetics_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants);     
                                        
                                        HopCycleNormalizedTime_Kinematics_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants);
                                        
                                        HopCycle_ContactPhaseKinematics_DesiredTrialLength = linspace(0,100, MaxKinematicTrialLengthAcrossParticipants_ContactPhase);
                                        
                                        HopCycleNormalizedTime_EMG_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants);
                                        
                                        HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength = linspace(0,100, MaxEMGTrialLengthAcrossParticipants_NotDownsampled);
                                        
                                        HopCycleNormalizedTime_Work_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants);
                                        
                                        HopCycleNormalizedTime_ContactPhaseWork_DesiredTrialLength = linspace(0,100, MaxKinematicTrialLengthAcrossParticipants_ContactPhase);

                                        HopCycleNormalizedTime_ContactPhaseEMG_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants_ContactPhase);
                                        
                                        HopCycleNormalizedTime_BrakingPhaseEMG_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants_BrakingPhase);
                                        
                                        HopCycleNormalizedTime_PropulsionPhaseEMG_DesiredTrialLength = linspace(0,100, MaxTrialLengthAcrossParticipants_PropulsionPhase);
                                        
                                        
                                        
                                        
%% INTERPOLATE                                        
                                        
                                        
                                        %Run interpolation function. First arg = time point vector with length
                                        %of the sth trial (i.e., ORIGINAL trial length); 2nd arg = the data for the sth trial; 3rd arg = time
                                        %point vector with DESIRED length
                                        
                                            %Interpolate the kinematic data. First angle, then
                                            %torque, then power
                                            
                                                    %First, interpolate the entire hop cycle
                                        Angle_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_Kinematics_SthTrialLength, LimbA_Angle_HoppingTrialR(1:LengthofHopCycle_MoCapSampHz( s ) - 1, s),...
                                            HopCycleNormalizedTime_Kinematics_DesiredTrialLength);
                                        
                                        Torque_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_Kinematics_SthTrialLength,LimbA_Torque_HoppingTrialR(1:LengthofHopCycle_MoCapSampHz( s ) - 1,s),...
                                            HopCycleNormalizedTime_Kinematics_DesiredTrialLength);
                                        
                                        Power_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_Kinematics_SthTrialLength,LimbA_Power_HoppingTrialR(1:LengthofHopCycle_MoCapSampHz( s ) - 1,s),...
                                            HopCycleNormalizedTime_Kinematics_DesiredTrialLength);
        %                                 RMEE_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(RHopCycleNormalizedTime_Work_SthTrialLength,MEE_HoppingTrialR(1:RWorkTrialLength_SthTrial,s),...
        %                                     RHopCycleNormalizedTime_Kinematics_DesiredTrialLength);                                

        
        
        
        
                                                    %Interpolate the contact phase of the kinematic
                                                    %data
                                        Angle_ContactPhase_Interpolated(1:MaxKinematicTrialLengthAcrossParticipants_ContactPhase,s) = interp1(HopCycleNormalizedTime_ContactPhaseKinematics_SthTrialLength,LimbA_Angle_ContactPhase_HoppingTrialR(1:LengthofContactPhase_MoCapSampHz(s) - 1,s),...
                                            HopCycle_ContactPhaseKinematics_DesiredTrialLength);
                                        
                                        Torque_ContactPhase_Interpolated(1:MaxKinematicTrialLengthAcrossParticipants_ContactPhase,s) = interp1(HopCycleNormalizedTime_ContactPhaseKinematics_SthTrialLength,LimbA_Torque_ContactPhase_HoppingTrialR(1:LengthofContactPhase_MoCapSampHz(s) - 1,s),...
                                            HopCycle_ContactPhaseKinematics_DesiredTrialLength);
                                        
                                        Power_ContactPhase_Interpolated(1:MaxKinematicTrialLengthAcrossParticipants_ContactPhase,s) = interp1(HopCycleNormalizedTime_ContactPhaseKinematics_SthTrialLength,LimbA_Power_ContactPhase_HoppingTrialR(1:LengthofContactPhase_MoCapSampHz(s) - 1,s),...
                                            HopCycle_ContactPhaseKinematics_DesiredTrialLength);
                                        
                                        Work_ContactPhase_Interpolated(1:MaxKinematicTrialLengthAcrossParticipants_ContactPhase,s) = interp1(HopCycleNormalizedTime_ContactPhaseWork_SthTrialLength,LimbA_Work_ContactPhase_HoppingTrialR(1:LengthofWorkData_MoCapSampHz( s) ,s),...
                                            HopCycle_ContactPhaseKinematics_DesiredTrialLength);


                                        
                                        
                                        
                                            %Interpolate the downsampled vGRF data
                                                    
                                                    %Unnormalized vGRF
                                        DownsampledVGRF_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_Kinetics_SthTrialLength,LimbA_VGRFdownsamp_HoppingTrialR(1 : LengthofDownsampledHopCycle_GRFSampHz( s ), s),...
                                            HopCycleNormalizedTime_Kinetics_DesiredTrialLength);
                                        
                                                    %Normalized vGRF
                                        DownsampledNormalizedVGRF_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_Kinetics_SthTrialLength,LimbA_VGRFdownsamp_Normalized_HoppingTrialR(1 : LengthofDownsampledHopCycle_GRFSampHz( s ), s),...
                                            HopCycleNormalizedTime_Kinetics_DesiredTrialLength);


                                        
                                        
                                        

                                            %Interpolate the downsampled, rectified EMG for each
                                            %muscle
                                        DownsampledRectifiedEMG_MedGas_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,MGas_Rectified_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledRectifiedEMG_LatGas_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,LGas_Rectified_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledRectifiedEMG_Sol_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,Sol_Rectified_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledRectifiedEMG_PL_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,PL_Rectified_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledRectifiedEMG_TA_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,TA_Rectified_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);


                                        
                                        


                                            %Interpolate the downsampled, normalized EMG for each
                                            %muscle
                                        DownsampledNormalizedEMG_MedGas_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,MGas_Normalized_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledNormalizedEMG_LatGas_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,LGas_Normalized_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledNormalizedEMG_Sol_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,Sol_Normalized_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledNormalizedEMG_PL_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,PL_Normalized_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);
                                        
                                        DownsampledNormalizedEMG_TA_Interpolated(1:MaxTrialLengthAcrossParticipants,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength,TA_Normalized_DownsampledEMG_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz_Downsampled( s ),s),...
                                            HopCycleNormalizedTime_EMG_DesiredTrialLength);




                                        
                                            %Interpolate the rectified, non-downsampled EMG for each
                                            %muscle
                                        RectifiedEMG_MedGas_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,MGas_Rectified_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        RectifiedEMG_LatGas_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,LGas_Rectified_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        RectifiedEMG_Sol_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,Sol_Rectified_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        RectifiedEMG_PL_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,PL_Rectified_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        RectifiedEMG_TA_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,TA_Rectified_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);




                                            %Interpolate the normalized, non-downsampled EMG for
                                            %each muscle
                                        NormalizedEMG_MedGas_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,MGas_Normalized_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        NormalizedEMG_LatGas_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,LGas_Normalized_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        NormalizedEMG_Sol_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,Sol_Normalized_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        NormalizedEMG_PL_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,PL_Normalized_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);
                                        NormalizedEMG_TA_Interpolated(1:MaxEMGTrialLengthAcrossParticipants_NotDownsampled,s) = interp1(HopCycleNormalizedTime_EMG_SthTrialLength_OriginalLength,TA_Normalized_HoppingTrialR(1 : LengthofHopCycle_EMGSampHz( s ),s),...
                                            HopCycleNormalizedTime_OriginalEMG_DesiredTrialLength);


                                        
                                        
                                        %Interpolate the rectified EMG for coherence
                                            %each muscle - CONTACT phase
                                        MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_ContactPhase, s ) = interp1( HopCycleNormalizedTime_ContactPhaseEMG_SthTrialLength, MedGas_RectifiedforCohere_Contact_HoppingTrialR(1 : LengthofContactPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_ContactPhaseEMG_DesiredTrialLength );
                                        
                                        LatGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_ContactPhase, s ) = interp1( HopCycleNormalizedTime_ContactPhaseEMG_SthTrialLength, LatGas_RectifiedforCohere_Contact_HoppingTrialR(1 : LengthofContactPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_ContactPhaseEMG_DesiredTrialLength );
                                        
                                        SolEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_ContactPhase, s ) = interp1( HopCycleNormalizedTime_ContactPhaseEMG_SthTrialLength, Sol_RectifiedforCohere_Contact_HoppingTrialR(1 : LengthofContactPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_ContactPhaseEMG_DesiredTrialLength );
                                        
                                        PLEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_ContactPhase, s ) = interp1( HopCycleNormalizedTime_ContactPhaseEMG_SthTrialLength, PL_RectifiedforCohere_Contact_HoppingTrialR(1 : LengthofContactPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_ContactPhaseEMG_DesiredTrialLength );
                                        
                                        TAEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_ContactPhase, s ) = interp1( HopCycleNormalizedTime_ContactPhaseEMG_SthTrialLength, TA_RectifiedforCohere_Contact_HoppingTrialR(1 : LengthofContactPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_ContactPhaseEMG_DesiredTrialLength );
                                        
                                        
                                        
                                        
                                        %Interpolate the rectified EMG for coherence
                                            %each muscle - BRAKING phase
                                        MedGasEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_BrakingPhase, s ) = interp1( HopCycleNormalizedTime_BrakingPhaseEMG_SthTrialLength, MedGas_RectifiedforCohere_Braking_HoppingTrialR(1 : LengthofBrakingPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_BrakingPhaseEMG_DesiredTrialLength );
                                        
                                        LatGasEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_BrakingPhase, s ) = interp1( HopCycleNormalizedTime_BrakingPhaseEMG_SthTrialLength, LatGas_RectifiedforCohere_Braking_HoppingTrialR(1 : LengthofBrakingPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_BrakingPhaseEMG_DesiredTrialLength );
                                        
                                        SolEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_BrakingPhase, s ) = interp1( HopCycleNormalizedTime_BrakingPhaseEMG_SthTrialLength, Sol_RectifiedforCohere_Braking_HoppingTrialR(1 : LengthofBrakingPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_BrakingPhaseEMG_DesiredTrialLength );
                                        
                                        PLEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_BrakingPhase, s ) = interp1( HopCycleNormalizedTime_BrakingPhaseEMG_SthTrialLength, PL_RectifiedforCohere_Braking_HoppingTrialR(1 : LengthofBrakingPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_BrakingPhaseEMG_DesiredTrialLength );
                                        
                                        TAEMG_Rectified_Braking4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_BrakingPhase, s ) = interp1( HopCycleNormalizedTime_BrakingPhaseEMG_SthTrialLength, TA_RectifiedforCohere_Braking_HoppingTrialR(1 : LengthofBrakingPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_BrakingPhaseEMG_DesiredTrialLength );
                                        
                                        
                                        
                                        
                                        %Interpolate the rectified EMG for coherence
                                            %each muscle - PROPULSION phase
                                        MedGasEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_PropulsionPhase, s ) = interp1( HopCycleNormalizedTime_PropulsionPhaseEMG_SthTrialLength, MedGas_RectifiedforCohere_Propulsion_HoppingTrialR(1 : LengthofPropulsionPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_PropulsionPhaseEMG_DesiredTrialLength );
                                        
                                        LatGasEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_PropulsionPhase, s ) = interp1( HopCycleNormalizedTime_PropulsionPhaseEMG_SthTrialLength, LatGas_RectifiedforCohere_Propulsion_HoppingTrialR(1 : LengthofPropulsionPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_PropulsionPhaseEMG_DesiredTrialLength );
                                        
                                        SolEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_PropulsionPhase, s ) = interp1( HopCycleNormalizedTime_PropulsionPhaseEMG_SthTrialLength, Sol_RectifiedforCohere_Propulsion_HoppingTrialR(1 : LengthofPropulsionPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_PropulsionPhaseEMG_DesiredTrialLength );
                                        
                                        PLEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_PropulsionPhase, s ) = interp1( HopCycleNormalizedTime_PropulsionPhaseEMG_SthTrialLength, PL_RectifiedforCohere_Propulsion_HoppingTrialR(1 : LengthofPropulsionPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_PropulsionPhaseEMG_DesiredTrialLength );
                                        
                                        TAEMG_Rectified_Propulsion4Cohere_Interpolated_ParticipantN( 1: MaxTrialLengthAcrossParticipants_PropulsionPhase, s ) = interp1( HopCycleNormalizedTime_PropulsionPhaseEMG_SthTrialLength, TA_RectifiedforCohere_Propulsion_HoppingTrialR(1 : LengthofPropulsionPhase_EMGSampHz( s ), s ),...
                                            HopCycleNormalizedTime_PropulsionPhaseEMG_DesiredTrialLength );
                                        
                                        

    %% Store Data in Data Structure



                                    end%End S For Loop - Individual Hops


                                




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    'vGRF','Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledVGRF_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    'vGRF','Normalized_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledNormalizedVGRF_Interpolated);




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Angle',HoppingRate_ID{b},HoppingTrialNumber{r},Angle_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Torque',HoppingRate_ID{b},HoppingTrialNumber{r},Torque_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Power',HoppingRate_ID{b},HoppingTrialNumber{r},Power_Interpolated);
        %                         David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
        %                             JointID{p},PlaneID{q},'MEE',HoppingRate_ID{b},HoppingTrialNumber{r},RMEE_Interpolated);



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Angle_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r},Angle_ContactPhase_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Torque_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r},Torque_ContactPhase_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Power_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r},Power_ContactPhase_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Work_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r},Work_ContactPhase_Interpolated);




                                 David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{1},'RectifiedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},RectifiedEMG_MedGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{2},'RectifiedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},RectifiedEMG_LatGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{3},'RectifiedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},RectifiedEMG_Sol_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{4},'RectifiedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},RectifiedEMG_PL_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{5},'RectifiedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},RectifiedEMG_TA_Interpolated);  




                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{1},'NormalizedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},NormalizedEMG_MedGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{2},'NormalizedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},NormalizedEMG_LatGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{3},'NormalizedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},NormalizedEMG_Sol_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{4},'NormalizedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},NormalizedEMG_PL_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{5},'NormalizedEMG_NotDownsampled',HoppingRate_ID{b},HoppingTrialNumber{r},NormalizedEMG_TA_Interpolated);         



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{1},'NormalizedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledNormalizedEMG_MedGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{2},'NormalizedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledNormalizedEMG_LatGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{3},'NormalizedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledNormalizedEMG_Sol_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{4},'NormalizedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledNormalizedEMG_PL_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{5},'NormalizedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledNormalizedEMG_TA_Interpolated);



                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{1},'RectifiedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledRectifiedEMG_MedGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{2},'RectifiedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledRectifiedEMG_LatGas_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{3},'RectifiedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledRectifiedEMG_Sol_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{4},'RectifiedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledRectifiedEMG_PL_Interpolated);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{5},'RectifiedEMG_Downsampled',HoppingRate_ID{b},HoppingTrialNumber{r},DownsampledRectifiedEMG_TA_Interpolated);       
                                
                                
                                
                                
                                %Save interpolated data for coherence analysis
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{1},'RectifiedEMG_forCoherence_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r},MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{2},'RectifiedEMG_forCoherence_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r}, MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{3},'RectifiedEMG_forCoherence_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r}, MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{4},'RectifiedEMG_forCoherence_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r}, MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN);
                                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},ParticipantList{n},'InterpolatedData',LimbID{a},...
                                    MuscleID{5},'RectifiedEMG_forCoherence_ContactPhase',HoppingRate_ID{b},HoppingTrialNumber{r}, MedGasEMG_Rectified_Contact4Cohere_Interpolated_ParticipantN);    
                            
                            
                            
%% End R For Loop - Hopping Bout
                                end




                            
                            


                            


                            %Calculate the ensemble average of vGRF for each participant and store in a matrix that will hold the averages for all participants.    
                            DownsampledVGRF_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledVGRF_Interpolated, 2, 'omitnan');
                            

                            %Calculate the ensemble average of normalized vGRF for each participant and store in a matrix that will hold the averages for all participants. 
                            DownsampledNormalizedVGRF_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledNormalizedVGRF_Interpolated, 2,'omitnan');
                            
                            

                            %Calculate the ensemble average of joint angle for each participant and store in a matrix that will hold the averages for all participants. 
                            Angle_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( Angle_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of joint torque for each participant and store in a matrix that will hold the averages for all participants. 
                            Torque_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( Torque_Interpolated ,2,'omitnan');
                            
                            
                            %Calculate the ensemble average of joint power for each participant and store in a matrix that will hold the averages for all participants. 
                            Power_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( Power_Interpolated ,2,'omitnan');







                            %Calculate the ensemble average of joint angle for each participant and store in a matrix that will hold the averages for all participants. 
                            Angle_ContactPhase_MeanInterpolatedFromEachParticipant = mean( Angle_ContactPhase_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of joint torque for each participant and store in a matrix that will hold the averages for all participants. 
                            Torque_ContactPhase_MeanInterpolatedFromEachParticipant = mean( Torque_ContactPhase_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of joint power for each participant and store in a matrix that will hold the averages for all participants. 
                            Power_ContactPhase_MeanInterpolatedFromEachParticipant = mean( Power_ContactPhase_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of joint power for each participant and store in a matrix that will hold the averages for all participants. 
                            Work_ContactPhase_MeanInterpolatedFromEachParticipant = mean( Work_ContactPhase_Interpolated ,2,'omitnan');









                            %Calculate the ensemble average of joint power for each participant and store in a matrix that will hold the averages for all participants. 
                            %RMEE_MeanInterpolatedFromEachParticipant = mean(RMEE_Interpolated_AllTrialsFromParticipantN,2,'omitnan');
                            %Last row of matrix stores the participant number
                            %RMEE_MeanInterpolatedFromEachParticipant(MaxTrialLengthAcrossParticipants+1) = n;



                            %Calculate the ensemble average of GasMed EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasMed_RectifiedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledRectifiedEMG_MedGas_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of GasLat EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasLat_RectifiedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledRectifiedEMG_LatGas_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of Sol EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            Sol_RectifiedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledRectifiedEMG_Sol_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of PL EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            PL_RectifiedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledRectifiedEMG_PL_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of TA EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            TA_RectifiedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledRectifiedEMG_TA_Interpolated ,2,'omitnan');







                            %Calculate the ensemble average of GasMed EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasMed_NormalizedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledNormalizedEMG_MedGas_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of GasLat EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasLat_NormalizedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledNormalizedEMG_LatGas_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of Sol EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            Sol_NormalizedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledNormalizedEMG_Sol_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of PL EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            PL_NormalizedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledNormalizedEMG_PL_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of TA EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            TA_NormalizedEMG_MeanInterpolatedFromEachParticipant( 1 : MaxTrialLengthAcrossParticipants, ColumntoFill ) = mean( DownsampledNormalizedEMG_TA_Interpolated ,2,'omitnan');










                            %Calculate the ensemble average of GasMed EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasMed_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( RectifiedEMG_MedGas_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of GasLat EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasLat_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( RectifiedEMG_LatGas_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of Sol EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            Sol_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( RectifiedEMG_Sol_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of PL EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            PL_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( RectifiedEMG_PL_Interpolated ,2,'omitnan');
                            

                            %Calculate the ensemble average of TA EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            TA_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( RectifiedEMG_TA_Interpolated ,2,'omitnan');





                            
                            


                            %Calculate the ensemble average of GasMed EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasMed_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( NormalizedEMG_MedGas_Interpolated ,2,'omitnan');

                            
                            %Calculate the ensemble average of GasLat EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            GasLat_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( NormalizedEMG_LatGas_Interpolated ,2,'omitnan');
                            
                            
                            %Calculate the ensemble average of Sol EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            Sol_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( NormalizedEMG_Sol_Interpolated ,2,'omitnan');

                            
                            %Calculate the ensemble average of PL EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            PL_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( NormalizedEMG_PL_Interpolated ,2,'omitnan');

                            
                            %Calculate the ensemble average of TA EMG for each participant and store in a matrix that will hold the averages for all participants. 
                            TA_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt( 1 : MaxEMGTrialLengthAcrossParticipants_NotDownsampled, ColumntoFill ) = mean( NormalizedEMG_TA_Interpolated ,2,'omitnan');
                            
    
%% Create table with ensemble averaged time series for BOTH groups


                %Create a column vector of the group ID, where the length is equal to MaxTrialLengthAcross
                %participants
                GroupID_Vector = repmat( m, MaxTrialLengthAcrossParticipants, 1);
                
                %Create a column vector of the participant ID, where the length is equal to MaxTrialLengthAcross
                %participants
                ParticipantID_Vector = repmat( n, MaxTrialLengthAcrossParticipants, 1);

                %Create a column vector of the limb ID, where the length is equal to MaxTrialLengthAcross
                %participants
                LimbID_Vector = repmat( a, MaxTrialLengthAcrossParticipants, 1);
                
                %Create time vector for the time series
                TimeVector = ( 1 : MaxTrialLengthAcrossParticipants )./MoCapSampHz;

                %Create a column vector of the hopping rate ID, where the length is equal to MaxTrialLengthAcross
                %participants
                HoppingRateID_Vector = repmat( HoppingRate_ID_forTable( b ), MaxTrialLengthAcrossParticipants, 1);
                
                %Create a column vector of the joint ID, where the length is equal to MaxTrialLengthAcross
                %participants
                JointID_Vector = repmat( p, MaxTrialLengthAcrossParticipants, 1);
                
                
                

                if m == 1 && n == 1 && a == 1 && b == 1 && p == 1

                    
                    TimeSeriesforR = [ GroupID_Vector, ParticipantID_Vector, LimbID_Vector, HoppingRateID_Vector, JointID_Vector, TimeVector',  DownsampledNormalizedVGRF_MeanInterpolatedFromEachParticipant,...
                        Angle_MeanInterpolatedFromEachParticipant, Torque_MeanInterpolatedFromEachParticipant,...
                            Power_MeanInterpolatedFromEachParticipant, GasMed_RectifiedEMG_MeanInterpolatedFromEachParticipant, GasLat_RectifiedEMG_MeanInterpolatedFromEachParticipant,...
                            Sol_RectifiedEMG_MeanInterpolatedFromEachParticipant,PL_RectifiedEMG_MeanInterpolatedFromEachParticipant, TA_RectifiedEMG_MeanInterpolatedFromEachParticipant,...
                            GasMed_NormalizedEMG_MeanInterpolatedFromEachParticipant, GasLat_NormalizedEMG_MeanInterpolatedFromEachParticipant, Sol_NormalizedEMG_MeanInterpolatedFromEachParticipant,...
                            PL_NormalizedEMG_MeanInterpolatedFromEachParticipant, TA_NormalizedEMG_MeanInterpolatedFromEachParticipant ];
                        
                        
                else
                    

                    TimeSeriesforR = [ TimeSeriesforR; GroupID_Vector, ParticipantID_Vector, LimbID_Vector,  HoppingRateID_Vector,  JointID_Vector, TimeVector', DownsampledNormalizedVGRF_MeanInterpolatedFromEachParticipant,...
                        Angle_MeanInterpolatedFromEachParticipant, Torque_MeanInterpolatedFromEachParticipant,...
                            Power_MeanInterpolatedFromEachParticipant, GasMed_RectifiedEMG_MeanInterpolatedFromEachParticipant, GasLat_RectifiedEMG_MeanInterpolatedFromEachParticipant,...
                            Sol_RectifiedEMG_MeanInterpolatedFromEachParticipant,PL_RectifiedEMG_MeanInterpolatedFromEachParticipant, TA_RectifiedEMG_MeanInterpolatedFromEachParticipant,...
                            GasMed_NormalizedEMG_MeanInterpolatedFromEachParticipant, GasLat_NormalizedEMG_MeanInterpolatedFromEachParticipant, Sol_NormalizedEMG_MeanInterpolatedFromEachParticipant,...
                            PL_NormalizedEMG_MeanInterpolatedFromEachParticipant, TA_NormalizedEMG_MeanInterpolatedFromEachParticipant ];

                end

                
 %% Export table with ensemble averaged time series for BOTH groups
 
 
                    VariableNames = {'Group_ID', 'Participant_ID' ,'Limb_ID', 'HoppingRate_ID', 'Joint_ID', 'TimeVector', ...
                        'VGRF_Normalized_Downsampled','JointAngle','JointTorque','JointPower',...
                        'MedGastroc_Rectified','LatGastroc_Rectified','Sol_Rectified','PL_Rectified','TA_Rectified',...
                        'MedGastroc_Normalized_NotDownsampled','LatGastroc_Normalized_NotDownsampled','Sol_Normalizedd_NotDownsampled','PL_Normalized_NotDownsampled','TA_Normalized_NotDownsampled'  };
%                 'Ankle_PercentMEEContribution','Knee_PercentMEEContribution',...
%                 'Hip_PercentMEEContribution',...


    TimeSeriesforR_ParticipantMean_Table = array2table(TimeSeriesforR,'VariableNames',VariableNames);

    writetable(TimeSeriesforR_ParticipantMean_Table, 'Hopping_InterGroupTimeSeries_ParticipantMeans_forR.xlsx' );
                
                
    
    

                
%% Store ensemble average for all participants in data structure
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    GRF_IDs{1},HoppingRate_ID{b},DownsampledVGRF_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            GRF_IDs{2},HoppingRate_ID{b},DownsampledNormalizedVGRF_MeanInterpolatedFromEachParticipant);

                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Angle',HoppingRate_ID{b},Angle_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Torque',HoppingRate_ID{b},Torque_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Power',HoppingRate_ID{b},Power_MeanInterpolatedFromEachParticipant);

    %                    David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
    %                                 JointID{p},PlaneID{q},'MEE',RMEE_MeanInterpolatedFromEachParticipant);         


                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Angle_ContactPhase',HoppingRate_ID{b},Angle_ContactPhase_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Torque_ContactPhase',HoppingRate_ID{b},Torque_ContactPhase_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Power_ContactPhase',HoppingRate_ID{b},Power_ContactPhase_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                                    JointID{p},PlaneID{q},'Work_ContactPhase',HoppingRate_ID{b},Work_ContactPhase_MeanInterpolatedFromEachParticipant);






                       David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'MGastroc_Rectified_NotDownsampled',HoppingRate_ID{b},GasMed_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'LGastroc_Rectified_NotDownsampled',HoppingRate_ID{b},GasLat_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'Sol_Rectified_NotDownsampled',HoppingRate_ID{b},Sol_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'PL_Rectified_NotDownsampled',HoppingRate_ID{b},PL_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'TA_Rectified_NotDownsampled',HoppingRate_ID{b},TA_RectifiedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);



                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'MGastroc_Normalized_NotDownsampled',HoppingRate_ID{b},GasMed_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'LGastroc_Normalized_NotDownsampled',HoppingRate_ID{b},GasLat_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'Sol_Normalized_NotDownsampled',HoppingRate_ID{b},Sol_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'PL_Normalized_NotDownsampled',HoppingRate_ID{b},PL_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'TA_Normalized_NotDownsampled',HoppingRate_ID{b},TA_NormalizedEMG_OriginalLength_MnInterpolatedEachPrtcpnt);  








                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'MGastroc_Rectified_Downsampled',HoppingRate_ID{b},GasMed_RectifiedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'LGastroc_Rectified_Downsampled',HoppingRate_ID{b},GasLat_RectifiedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'Sol_Rectified_Downsampled',HoppingRate_ID{b},Sol_RectifiedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'PL_Rectified_Downsampled',HoppingRate_ID{b},PL_RectifiedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'TA_Rectified_Downsampled',HoppingRate_ID{b},TA_RectifiedEMG_MeanInterpolatedFromEachParticipant);



                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'MGastroc_Normalized_Downsampled',HoppingRate_ID{b},GasMed_NormalizedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'LGastroc_Normalized_Downsampled',HoppingRate_ID{b},GasLat_NormalizedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'Sol_Normalized_Downsampled',HoppingRate_ID{b},Sol_NormalizedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'PL_Normalized_Downsampled',HoppingRate_ID{b},PL_NormalizedEMG_MeanInterpolatedFromEachParticipant);
                        David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            'TA_Normalized_Downsampled',HoppingRate_ID{b},TA_NormalizedEMG_MeanInterpolatedFromEachParticipant);    
                        
                        
                        
                        
                        
                            end%End For Loop for Hopping Rate
                        
                        end%End For Loop for Plane of Motion

                    end%End For Loop for Joint ID

                
            end%End For Loop - Limb ID
            
        end%End For Loop - Participant List
        
    end%End For Loop - Group List
    
end%End For Loop - Data Category






%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 7',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end










%% SECTION 8 - Write Data to Table and Export for Plotting in R - One Table Per Group


for l = 1:numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});
        
%% M Loop - Run Once Per Group
    
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
            
            LimbID = {'InvolvedLimb','NonInvolvedLimb'};
               


        else

            ParticipantList = ControlParticipantList;

            ParticipantMass = ControlParticipantMass;
            
            LimbID = { 'RightLimb', 'LeftLimb' };


        end
        

        
        
        
        %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
        AllParticipantsVariables_DataStructure = getfield(ParticipantListDataStructure,'AllParticipants');
        
        %Use get field to create a new data structure containing the list of categories under Individual Hops. Stored under the 4th field of the structure (the list of data categories)
        InterpolatedData_DataStructure = getfield(AllParticipantsVariables_DataStructure,'InterpolatedData');

            
        
%% A For Loop - Run Once Per Limb
        for a = 1 : numel(LimbID)
        
                
                
                    
                %Use getfield to create a new data structure containing the data for Limb A
                ListofLimbIDs_DataStructure = getfield( InterpolatedData_DataStructure, LimbID{ a } );            
            

            

                
 %% B For Loop - Run Once Per Hopping Rate               


                    Ankle = getfield( ListofLimbIDs_DataStructure, 'Ankle' );
                    Knee = getfield( ListofLimbIDs_DataStructure, 'Knee' );
                    Hip = getfield( ListofLimbIDs_DataStructure, 'Hip' );
                    
                    
                    AnkleSagittal = getfield(Ankle, 'Sagittal');
                    KneeSagittal = getfield(Knee, 'Sagittal');
                    HipSagittal = getfield(Hip, 'Sagittal');
                    
                    
                for b = 1:numel(HoppingRate_ID)
                    


                        %Create variables containing the joint angle/torque/power and vGRF data
                        %from the rth trial of hops
                        AnkleAngle = getfield(AnkleSagittal.Angle, HoppingRate_ID{b});
                        AnkleTorque = getfield(AnkleSagittal.Torque, HoppingRate_ID{b});
                        AnklePower = getfield(AnkleSagittal.Power, HoppingRate_ID{b});


                        KneeAngle = getfield(KneeSagittal.Angle, HoppingRate_ID{b});
                        KneeTorque = getfield(KneeSagittal.Torque, HoppingRate_ID{b});
                        KneePower = getfield(KneeSagittal.Power, HoppingRate_ID{b});


                        HipAngle = getfield(HipSagittal.Angle, HoppingRate_ID{b});
                        HipTorque = getfield(HipSagittal.Torque, HoppingRate_ID{b});
                        HipPower = getfield(HipSagittal.Power, HoppingRate_ID{b});


                        %Create variables containing the data structure for each muscle
                        %Will contain individual data structure each for trial


                        MedGastroc_Rectified = getfield(  ListofLimbIDs_DataStructure.MGastroc_Rectified_Downsampled, HoppingRate_ID{b} );
                        LatGastroc_Rectified = getfield(  ListofLimbIDs_DataStructure.LGastroc_Rectified_Downsampled, HoppingRate_ID{b} );
                        Sol_Rectified = getfield(  ListofLimbIDs_DataStructure.Sol_Rectified_Downsampled, HoppingRate_ID{b} );
                        PL_Rectified = getfield(  ListofLimbIDs_DataStructure.PL_Rectified_Downsampled, HoppingRate_ID{b} );
                        TA_Rectified = getfield(  ListofLimbIDs_DataStructure.TA_Rectified_Downsampled, HoppingRate_ID{b} );


                        MedGastroc = getfield(  ListofLimbIDs_DataStructure.MGastroc_Normalized_Downsampled, HoppingRate_ID{b} );
                        LatGastroc = getfield(  ListofLimbIDs_DataStructure.LGastroc_Normalized_Downsampled, HoppingRate_ID{b} );
                        Sol = getfield(  ListofLimbIDs_DataStructure.Sol_Normalized_Downsampled, HoppingRate_ID{b} );
                        PL = getfield(  ListofLimbIDs_DataStructure.PL_Normalized_Downsampled, HoppingRate_ID{b} );
                        TA = getfield(  ListofLimbIDs_DataStructure.TA_Normalized_Downsampled, HoppingRate_ID{b} );
                        
                        

                    
                        VGRF_Normalized_Downsampled = getfield(  ListofLimbIDs_DataStructure.VGRF_Normalized_Downsampled, HoppingRate_ID{b} );






                    NumberofRows = size(VGRF_Normalized_Downsampled, 1);
                    

                    
                    HoppingRateID = repmat( HoppingRate_ID_forTable(b),  NumberofRows, 1);
 
                    
                    
                    
                    
                    

                    DataforR = [ mean(VGRF_Normalized_Downsampled,2,'omitnan'), mean(AnkleAngle,2,'omitnan'), mean(AnkleTorque,2,'omitnan'),...
                        mean(AnklePower,2,'omitnan'),...
                        mean(KneeAngle,2,'omitnan'), mean(KneeTorque,2,'omitnan'), mean(KneePower,2,'omitnan'),...
                        mean(HipAngle,2,'omitnan'), mean(HipTorque,2,'omitnan'), mean(HipPower,2,'omitnan'),...
                        mean(MedGastroc_Rectified,2,'omitnan'), mean(LatGastroc_Rectified,2,'omitnan'), mean(Sol_Rectified,2,'omitnan'),...
                        mean(PL_Rectified,2,'omitnan'),...
                        mean(TA_Rectified,2,'omitnan'), mean(MedGastroc,2,'omitnan'),...
                        mean(LatGastroc,2,'omitnan'), mean(Sol,2,'omitnan'), mean(PL,2,'omitnan'), mean(TA,2,'omitnan'),...
                        HoppingRateID];
                        %Ankle_PercentMEEContribution,Knee_PercentMEEContribution,Hip_PercentMEEContribution,...


                    VariableNames = {'VGRF_Normalized_Downsampled','AnkleAngle','AnkleTorque','AnklePower',...
                        'KneeAngle','KneeTorque','KneePower','HipAngle','HipTorque','HipPower',...
                        'MedGastroc_Rectified','LatGastroc_Rectified','Sol_Rectified','PL_Rectified','TA_Rectified',...
                        'MedGastroc_Normalized_NotDownsampled','LatGastroc_Normalized_NotDownsampled','Sol_Normalized','PL_Normalized_NotDownsampled','TA_Normalized_NotDownsampled','HoppingRate_ID'};
            %                 'Ankle_PercentMEEContribution','Knee_PercentMEEContribution',...
            %                 'Hip_PercentMEEContribution',...


                    DataforR_Table = array2table(DataforR,'VariableNames',VariableNames);

                    writetable(DataforR_Table,[ 'Post_Quals', GroupList{m}, '_' , LimbID{a}, '_',  '_', HoppingRate_ID{b} , '_', 'DataforR.xlsx'] );
           
                
                end %End B Loop - Run Once Per Hopping Rate
                
            end

        end
        
end

    





%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 8',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end













%% SECTION 9 - Write Data to Table and Export for Plotting in R - One Table For All Groups, Individual Hops


DataforR = NaN( 132, 31 );
DataforR_Table = NaN( 132, 31 );
NumberofHops = 10;


for l = 1:numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});
        
%% M Loop - Run Once Per Group
    
    for m = 1:numel(GroupList)

        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
       ListofParticipants_DataStructure = getfield(GroupListDataStructure,GroupList{m});
        
        
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
            if strcmp( GroupList{m}, 'ATx' )
            
                ParticipantList = ATxParticipantList;

                ParticipantMass = ATxParticipantMass;

                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
            
            else
            
                ParticipantList = ControlParticipantList;

                ParticipantMass = ControlParticipantMass;

                HoppingRate_ID = { 'TwoPoint2Hz', 'TwoPoint3Hz' };
            
            end
            
        
    %% N For Loop - Run Once Per Participant
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
            VariablesforParticipantN_DataStructure = getfield(ListofParticipants_DataStructure, ParticipantList{ n } );

            %Use get field to create a new data structure containing the list of categories under Individual Hops. Stored under the 4th field of the structure (the list of data categories)
            InterpolatedData_DataStructure = getfield( VariablesforParticipantN_DataStructure, 'InterpolatedData' );



            
            
            
    %% A For Loop - Run Once Per Limb
            for a = 1 : numel(LimbID)


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
                         MuscleID = {'RMGas','RLGas','RSol','RPL' };
                         
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
                
                
                    
                %Use getfield to create a new data structure containing the data for Limb A
                ListofLimbIDs_DataStructure = getfield( InterpolatedData_DataStructure, LimbID{ a } );            
            



                 
                    
                    MedGastrocVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{1} );
                    LatGastrocVariables_DataStructure = getfield( ListofLimbIDs_DataStructure, MuscleID{2} );
                    SolVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{3} );
                    PLVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{4} );
                    TAVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{5} );

                    
                    
    %% B For Loop - Run Once Per Hopping Rate             
                    
                    for b = 1 : numel( HoppingRate_ID )
                        
                        

                        
                        vGRF_Normalized_Downsampled_OneHoppingRate = getfield( ListofLimbIDs_DataStructure.vGRF.Normalized_Downsampled, HoppingRate_ID{b} );
                        
                        
                        
                        %Store angle/torque/power data for all joints and all participants in temporary variables
                        AnkleTorque_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Ankle.Sagittal.Torque, HoppingRate_ID{b} );
                        AnkleAngle_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Ankle.Sagittal.Angle, HoppingRate_ID{b} );
                        AnklePower_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Ankle.Sagittal.Power, HoppingRate_ID{b} );
                        %AnkleMEE = Joint_DataStructure.Ankle.Sagittal.MEE, HoppingTrialNumber{p} );

                        KneeTorque_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Knee.Sagittal.Torque, HoppingRate_ID{b} );
                        KneeAngle_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Knee.Sagittal.Angle, HoppingRate_ID{b} );
                        KneePower_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Knee.Sagittal.Power, HoppingRate_ID{b} );
                        %KneeMEE = Joint_DataStructure.Knee.Sagittal.MEE, HoppingTrialNumber{p} );

                        HipTorque_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Hip.Sagittal.Torque, HoppingRate_ID{b} );
                        HipAngle_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Hip.Sagittal.Angle, HoppingRate_ID{b} );
                        HipPower_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Hip.Sagittal.Power, HoppingRate_ID{b} );
                        %HipMEE = Joint_DataStructure.Hip.Sagittal.MEE, HoppingTrialNumber{p} );
                        %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});





                        MedGastroc_Rectified_OneHoppingRate = getfield( MedGastrocVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        LatGastroc_Rectified_OneHoppingRate = getfield( LatGastrocVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        Sol_Rectified_OneHoppingRate = getfield( SolVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        PL_Rectified_OneHoppingRate = getfield( PLVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        TA_Rectified_OneHoppingRate = getfield( TAVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );


                        MedGastroc_OneHoppingRate = getfield( MedGastrocVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        LatGastroc_OneHoppingRate = getfield( LatGastrocVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        Sol_OneHoppingRate = getfield( SolVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        PL_OneHoppingRate = getfield( PLVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        TA_OneHoppingRate = getfield( TAVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        
                        
                        
                            if strcmp( ParticipantList{n}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz' )
                                
                                HoppingTrialNumber = {'Trial1'};
                                

                            elseif strcmp( ParticipantList{n}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )
                                
                                HoppingTrialNumber = {'Trial1','Trial2'};
                                
                                
                            else

                                HoppingTrialNumber = {'Trial1'};
                                
                            end
                    
                            
                            
                            
                            
    %% P For Loop - Run Once Per HoppingTrialNumber                        
                        
                        for p = 1 : numel(HoppingTrialNumber)

                            %Store normalized vGRF data for all participants in a temporary variable
                            VGRF_Normalized_Downsampled = getfield( vGRF_Normalized_Downsampled_OneHoppingRate, HoppingTrialNumber{p} );
                            %Find length of vGRF data. Last row of matrix contains participant number
                            TrialLength_VGRF = size(VGRF_Normalized_Downsampled,1);
                            NumberofHops = size(VGRF_Normalized_Downsampled,2);

                            %Calculate time in seconds. Create sequence from 1 through length of vGRF data, divide by
                            %60 because sampling Hz is 60 - will give seconds.
                            TimeVector = (1:TrialLength_VGRF)./300;


                            %Store angle/torque/power data for all joints and all participants in temporary variables
                            AnkleTorque = getfield( AnkleTorque_OneHoppingRate, HoppingTrialNumber{p} );
                            AnkleAngle = getfield( AnkleAngle_OneHoppingRate, HoppingTrialNumber{p} );
                            AnklePower = getfield( AnklePower_OneHoppingRate, HoppingTrialNumber{p} );
                            %AnkleMEE = Joint_DataStructure.Ankle.Sagittal.MEE, HoppingTrialNumber{p} );

                            KneeTorque = getfield( KneeTorque_OneHoppingRate, HoppingTrialNumber{p} );
                            KneeAngle = getfield(  KneeAngle_OneHoppingRate, HoppingTrialNumber{p} );
                            KneePower = getfield(  KneePower_OneHoppingRate, HoppingTrialNumber{p} );
                            %KneeMEE = Joint_DataStructure.Knee.Sagittal.MEE, HoppingTrialNumber{p} );

                            HipTorque = getfield( HipTorque_OneHoppingRate, HoppingTrialNumber{p} );
                            HipAngle = getfield( HipAngle_OneHoppingRate, HoppingTrialNumber{p} );
                            HipPower = getfield( HipPower_OneHoppingRate, HoppingTrialNumber{p} );
                            %HipMEE = Joint_DataStructure.Hip.Sagittal.MEE, HoppingTrialNumber{p} );
                            %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});


                            WholeLimb_Torque = AnkleTorque+KneeTorque+HipTorque;
                            Ankle_PercentTorqueContribution = AnkleTorque./WholeLimb_Torque;
                            Knee_PercentTorqueContribution = KneeTorque./WholeLimb_Torque;
                            Hip_PercentTorqueContribution = HipTorque./WholeLimb_Torque;

                    %             WholeLimb_MEE = AnkleMEE+KneeMEE+HipMEE;
                    %             Ankle_PercentMEEContribution = AnkleMEE./WholeLimb_MEE;
                    %             Knee_PercentMEEContribution = KneeMEE./WholeLimb_MEE;
                    %             Hip_PercentMEEContribution = HipMEE./WholeLimb_MEE;




                            MedGastroc_Rectified = getfield( MedGastroc_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            LatGastroc_Rectified = getfield( LatGastroc_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            Sol_Rectified = getfield( Sol_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            PL_Rectified = getfield( PL_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            TA_Rectified = getfield( TA_Rectified_OneHoppingRate, HoppingTrialNumber{p} );


                            MedGastroc = getfield( MedGastroc_OneHoppingRate, HoppingTrialNumber{p} );
                            LatGastroc = getfield( LatGastroc_OneHoppingRate, HoppingTrialNumber{p} );
                            Sol = getfield( Sol_OneHoppingRate, HoppingTrialNumber{p} );
                            PL = getfield( PL_OneHoppingRate, HoppingTrialNumber{p} );
                            TA = getfield( TA_OneHoppingRate, HoppingTrialNumber{p} );


                            for s = 1 : NumberofHops

                                VGRF_Normalized_Downsampled_HopS = VGRF_Normalized_Downsampled( :, s );

                                AnkleTorque_HopS = AnkleTorque( :, s );
                                AnkleAngle_HopS = AnkleAngle( :, s );
                                AnklePower_HopS = AnklePower( :, s );
                                %AnkleMEE = Joint_DataStructure.Ankle.Sagittal.MEE, HoppingTrialNumber{p} );

                                KneeTorque_HopS = KneeTorque( :, s );
                                KneeAngle_HopS = KneeAngle( :, s );
                                KneePower_HopS = KneePower( :, s );
                                %KneeMEE = Joint_DataStructure.Knee.Sagittal.MEE, HoppingTrialNumber{p} );

                                HipTorque_HopS = HipTorque( :, s );
                                HipAngle_HopS = HipAngle( :, s );
                                HipPower_HopS = HipPower( :, s );
                                %HipMEE = Joint_DataStructure.Hip.Sagittal.MEE, HoppingTrialNumber{p} );
                                %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});


                                WholeLimb_Torque_HopS = AnkleTorque_HopS+KneeTorque_HopS+HipTorque_HopS;
                                Ankle_PercentTorqueContribution_HopS = AnkleTorque_HopS./WholeLimb_Torque_HopS;
                                Knee_PercentTorqueContribution_HopS = KneeTorque_HopS./WholeLimb_Torque_HopS;
                                Hip_PercentTorqueContribution_HopS = HipTorque_HopS./WholeLimb_Torque_HopS;

                        %             WholeLimb_MEE = AnkleMEE+KneeMEE+HipMEE;
                        %             Ankle_PercentMEEContribution = AnkleMEE./WholeLimb_MEE;
                        %             Knee_PercentMEEContribution = KneeMEE./WholeLimb_MEE;
                        %             Hip_PercentMEEContribution = HipMEE./WholeLimb_MEE;


                                MedGastroc_Rectified_HopS = MedGastroc_Rectified( :, s );
                                LatGastroc_Rectified_HopS = LatGastroc_Rectified( :, s );
                                Sol_Rectified_HopS = Sol_Rectified( :, s );
                                PL_Rectified_HopS = PL_Rectified( :, s );
                                TA_Rectified_HopS = TA_Rectified( :, s );


                                MedGastroc_HopS = MedGastroc( :, s );
                                LatGastroc_HopS = LatGastroc( :, s );
                                Sol_HopS = Sol( :, s );
                                PL_HopS = PL( :, s );
                                TA_HopS = TA( :, s );



                                Group_ID = repmat( m, numel(WholeLimb_Torque_HopS), 1);
                                Participant_ID = repmat( n, numel(WholeLimb_Torque_HopS), 1);
                                Limb_ID = repmat( a, numel(WholeLimb_Torque_HopS), 1);
                                Trial_ID = repmat( p, numel(WholeLimb_Torque_HopS), 1);
                                Hop_ID = repmat( s, numel(WholeLimb_Torque_HopS), 1);
                                HoppingRateID = repmat( HoppingRate_ID_forTable( b ), numel(WholeLimb_Torque_HopS), 1);
                                
                                

                                
                                
                                
                                
                                
                                
                                

                                TimeVector = (1 : numel(WholeLimb_Torque_HopS) ) ./ 300;



                                if m == 1 && a == 1 &&  p == 1 && s == 1

                                    DataforR = [VGRF_Normalized_Downsampled_HopS,...
                                        AnkleAngle_HopS,  AnkleTorque_HopS,  AnklePower_HopS,...
                                        KneeAngle_HopS,  KneeTorque_HopS,  KneePower_HopS,...
                                        HipAngle_HopS,  HipTorque_HopS,  HipPower_HopS,...
                                        MedGastroc_Rectified_HopS,  LatGastroc_Rectified_HopS,  Sol_Rectified_HopS,  PL_Rectified_HopS,  TA_Rectified_HopS,...
                                        MedGastroc_HopS,  LatGastroc_HopS,  Sol_HopS,  PL_HopS,  TA_HopS,...
                                        Group_ID, Participant_ID ,Limb_ID, Trial_ID,Hop_ID, TimeVector', HoppingRateID];
                                        %Ankle_PercentMEEContribution,Knee_PercentMEEContribution,Hip_PercentMEEContribution,...

                                else

                                    DataforR = [ DataforR; VGRF_Normalized_Downsampled_HopS,...
                                        AnkleAngle_HopS,  AnkleTorque_HopS,  AnklePower_HopS,...
                                        KneeAngle_HopS,  KneeTorque_HopS,  KneePower_HopS,...
                                        HipAngle_HopS,  HipTorque_HopS,  HipPower_HopS,...
                                        MedGastroc_Rectified_HopS,  LatGastroc_Rectified_HopS,  Sol_Rectified_HopS,  PL_Rectified_HopS,  TA_Rectified_HopS,...
                                        MedGastroc_HopS,  LatGastroc_HopS,  Sol_HopS,  PL_HopS,  TA_HopS,...
                                        Group_ID, Participant_ID ,Limb_ID, Trial_ID,Hop_ID, TimeVector', HoppingRateID ];

                                end



                            end

                        end
                    
                    end%End B For Loop - Hopping Rate ID
                    
                end
                
            end
            
        end


    
    VariableNames = {'VGRF_Normalized_Downsampled','AnkleAngle','AnkleTorque','AnklePower',...
    'KneeAngle','KneeTorque','KneePower','HipAngle','HipTorque','HipPower',...
    'MedGastroc_Rectified','LatGastroc_Rectified','Sol_Rectified','PL_Rectified','TA_Rectified',...
    'MedGastroc_Normalized_NotDownsampled','LatGastroc_Normalized_NotDownsampled','Sol_Normalized','PL_Normalized_NotDownsampled','TA_Normalized_NotDownsampled','Group_ID', 'Participant_ID' ,'Limb_ID','Trial_ID','Hop_ID', 'TimeVector', 'HoppingRate_ID'};
%                 'Ankle_PercentMEEContribution','Knee_PercentMEEContribution',...
%                 'Hip_PercentMEEContribution',...


    DataforR_Table = array2table(DataforR,'VariableNames',VariableNames);

    writetable(DataforR_Table, 'InterGroupTimeSeries_IndividualHops_forR.xlsx' );
    
end



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 9',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end








%% SECTION 10 - Write Data to Table and Export for Plotting in R - One Table For All Groups, Participant Means


TimeSeriesforR_ParticipantMean = NaN( 132, 27 );
TimeSeriesforR_ParticipantMean_Table = NaN( 132, 27 );


for l = 1:numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});
        
%% M Loop - Run Once Per Group
    
    for m = 1:numel(GroupList)

        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
       ListofParticipants_DataStructure = getfield(GroupListDataStructure,GroupList{m});
        
        
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
            if strcmp( GroupList{m}, 'ATx' )
            
                ParticipantList = ATxParticipantList;

                ParticipantMass = ATxParticipantMass;

                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
            
            else
            
                ParticipantList = ControlParticipantList;

                ParticipantMass = ControlParticipantMass;

                HoppingRate_ID = { 'TwoPoint2Hz', 'TwoPoint3Hz' };
            
            end
            
        
    %% N For Loop - Run Once Per Participant
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
            VariablesforParticipantN_DataStructure = getfield(ListofParticipants_DataStructure, ParticipantList{ n } );

            %Use get field to create a new data structure containing the list of categories under Individual Hops. Stored under the 4th field of the structure (the list of data categories)
            InterpolatedData_DataStructure = getfield( VariablesforParticipantN_DataStructure, 'InterpolatedData' );



            
            
            
    %% A For Loop - Run Once Per Limb
            for a = 1 : numel(LimbID)


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
                         MuscleID = {'RMGas','RLGas','RSol','RPL' };
                         
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
                
                
                    
                %Use getfield to create a new data structure containing the data for Limb A
                ListofLimbIDs_DataStructure = getfield( InterpolatedData_DataStructure, LimbID{ a } );            
            



                 
                    
                    MedGastrocVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{1} );
                    LatGastrocVariables_DataStructure = getfield( ListofLimbIDs_DataStructure, MuscleID{2} );
                    SolVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{3} );
                    PLVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{4} );
                    TAVariables_DataStructure = getfield(  ListofLimbIDs_DataStructure, MuscleID{5} );

                    
                    
    %% B For Loop - Run Once Per Hopping Rate             
                    
                    for b = 1 : numel( HoppingRate_ID )
                        
                        

                        
                        vGRF_Normalized_Downsampled_OneHoppingRate = getfield( ListofLimbIDs_DataStructure.vGRF.Normalized_Downsampled, HoppingRate_ID{b} );
                        
                        
                        
                        %Store angle/torque/power data for all joints and all participants in temporary variables
                        AnkleTorque_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Ankle.Sagittal.Torque, HoppingRate_ID{b} );
                        AnkleAngle_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Ankle.Sagittal.Angle, HoppingRate_ID{b} );
                        AnklePower_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Ankle.Sagittal.Power, HoppingRate_ID{b} );
                        %AnkleMEE = Joint_DataStructure.Ankle.Sagittal.MEE, HoppingTrialNumber{p} );

                        KneeTorque_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Knee.Sagittal.Torque, HoppingRate_ID{b} );
                        KneeAngle_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Knee.Sagittal.Angle, HoppingRate_ID{b} );
                        KneePower_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Knee.Sagittal.Power, HoppingRate_ID{b} );
                        %KneeMEE = Joint_DataStructure.Knee.Sagittal.MEE, HoppingTrialNumber{p} );

                        HipTorque_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Hip.Sagittal.Torque, HoppingRate_ID{b} );
                        HipAngle_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Hip.Sagittal.Angle, HoppingRate_ID{b} );
                        HipPower_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.Hip.Sagittal.Power, HoppingRate_ID{b} );
                        %HipMEE = Joint_DataStructure.Hip.Sagittal.MEE, HoppingTrialNumber{p} );
                        %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});





                        MedGastroc_Rectified_OneHoppingRate = getfield( MedGastrocVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        LatGastroc_Rectified_OneHoppingRate = getfield( LatGastrocVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        Sol_Rectified_OneHoppingRate = getfield( SolVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        PL_Rectified_OneHoppingRate = getfield( PLVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );
                        TA_Rectified_OneHoppingRate = getfield( TAVariables_DataStructure.RectifiedEMG_Downsampled, HoppingRate_ID{b} );


                        MedGastroc_OneHoppingRate = getfield( MedGastrocVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        LatGastroc_OneHoppingRate = getfield( LatGastrocVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        Sol_OneHoppingRate = getfield( SolVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        PL_OneHoppingRate = getfield( PLVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        TA_OneHoppingRate = getfield( TAVariables_DataStructure.NormalizedEMG_Downsampled, HoppingRate_ID{b} );
                        
                        
                        
                            if strcmp( ParticipantList{n}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz' )
                                
                                HoppingTrialNumber = {'Trial1'};
                                

                            elseif strcmp( ParticipantList{n}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )
                                
                                HoppingTrialNumber = {'Trial1','Trial2'};
                                
                                
                            else

                                HoppingTrialNumber = {'Trial1'};
                                
                            end
                    
                            
                            
                            
                            
    %% P For Loop - Run Once Per HoppingTrialNumber                        
                        
                        for p = 1 : numel(HoppingTrialNumber)

                            %Store normalized vGRF data for all participants in a temporary variable
                            VGRF_Normalized_Downsampled = getfield( vGRF_Normalized_Downsampled_OneHoppingRate, HoppingTrialNumber{p} );
                            %Find length of vGRF data. Last row of matrix contains participant number
                            TrialLength_VGRF = size(VGRF_Normalized_Downsampled,1);
                            NumberofHops = size(VGRF_Normalized_Downsampled,2);

                            %Calculate time in seconds. Create sequence from 1 through length of vGRF data, divide by
                            %60 because sampling Hz is 60 - will give seconds.
                            TimeVector = (1:TrialLength_VGRF)./300;


                            %Store angle/torque/power data for all joints and all participants in temporary variables
                            AnkleTorque = getfield( AnkleTorque_OneHoppingRate, HoppingTrialNumber{p} );
                            AnkleAngle = getfield( AnkleAngle_OneHoppingRate, HoppingTrialNumber{p} );
                            AnklePower = getfield( AnklePower_OneHoppingRate, HoppingTrialNumber{p} );
                            %AnkleMEE = Joint_DataStructure.Ankle.Sagittal.MEE, HoppingTrialNumber{p} );

                            KneeTorque = getfield( KneeTorque_OneHoppingRate, HoppingTrialNumber{p} );
                            KneeAngle = getfield(  KneeAngle_OneHoppingRate, HoppingTrialNumber{p} );
                            KneePower = getfield(  KneePower_OneHoppingRate, HoppingTrialNumber{p} );
                            %KneeMEE = Joint_DataStructure.Knee.Sagittal.MEE, HoppingTrialNumber{p} );

                            HipTorque = getfield( HipTorque_OneHoppingRate, HoppingTrialNumber{p} );
                            HipAngle = getfield( HipAngle_OneHoppingRate, HoppingTrialNumber{p} );
                            HipPower = getfield( HipPower_OneHoppingRate, HoppingTrialNumber{p} );
                            %HipMEE = Joint_DataStructure.Hip.Sagittal.MEE, HoppingTrialNumber{p} );
                            %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});


                            WholeLimb_Torque = AnkleTorque+KneeTorque+HipTorque;
                            Ankle_PercentTorqueContribution = AnkleTorque./WholeLimb_Torque;
                            Knee_PercentTorqueContribution = KneeTorque./WholeLimb_Torque;
                            Hip_PercentTorqueContribution = HipTorque./WholeLimb_Torque;

                    %             WholeLimb_MEE = AnkleMEE+KneeMEE+HipMEE;
                    %             Ankle_PercentMEEContribution = AnkleMEE./WholeLimb_MEE;
                    %             Knee_PercentMEEContribution = KneeMEE./WholeLimb_MEE;
                    %             Hip_PercentMEEContribution = HipMEE./WholeLimb_MEE;




                            MedGastroc_Rectified = getfield( MedGastroc_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            LatGastroc_Rectified = getfield( LatGastroc_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            Sol_Rectified = getfield( Sol_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            PL_Rectified = getfield( PL_Rectified_OneHoppingRate, HoppingTrialNumber{p} );
                            TA_Rectified = getfield( TA_Rectified_OneHoppingRate, HoppingTrialNumber{p} );


                            MedGastroc = getfield( MedGastroc_OneHoppingRate, HoppingTrialNumber{p} );
                            LatGastroc = getfield( LatGastroc_OneHoppingRate, HoppingTrialNumber{p} );
                            Sol = getfield( Sol_OneHoppingRate, HoppingTrialNumber{p} );
                            PL = getfield( PL_OneHoppingRate, HoppingTrialNumber{p} );
                            TA = getfield( TA_OneHoppingRate, HoppingTrialNumber{p} );


                            for s = 1 : NumberofHops

                                VGRF_Normalized_Downsampled_HopS = VGRF_Normalized_Downsampled( :, s );

                                AnkleTorque_HopS = AnkleTorque( :, s );
                                AnkleAngle_HopS = AnkleAngle( :, s );
                                AnklePower_HopS = AnklePower( :, s );
                                %AnkleMEE = Joint_DataStructure.Ankle.Sagittal.MEE, HoppingTrialNumber{p} );

                                KneeTorque_HopS = KneeTorque( :, s );
                                KneeAngle_HopS = KneeAngle( :, s );
                                KneePower_HopS = KneePower( :, s );
                                %KneeMEE = Joint_DataStructure.Knee.Sagittal.MEE, HoppingTrialNumber{p} );

                                HipTorque_HopS = HipTorque( :, s );
                                HipAngle_HopS = HipAngle( :, s );
                                HipPower_HopS = HipPower( :, s );
                                %HipMEE = Joint_DataStructure.Hip.Sagittal.MEE, HoppingTrialNumber{p} );
                                %LLimb_HoppingTrialP = getfield(LLimb_HoppingTrialNumbers,HoppingTrialNumber{p});


                                WholeLimb_Torque_HopS = AnkleTorque_HopS+KneeTorque_HopS+HipTorque_HopS;
                                Ankle_PercentTorqueContribution_HopS = AnkleTorque_HopS./WholeLimb_Torque_HopS;
                                Knee_PercentTorqueContribution_HopS = KneeTorque_HopS./WholeLimb_Torque_HopS;
                                Hip_PercentTorqueContribution_HopS = HipTorque_HopS./WholeLimb_Torque_HopS;

                        %             WholeLimb_MEE = AnkleMEE+KneeMEE+HipMEE;
                        %             Ankle_PercentMEEContribution = AnkleMEE./WholeLimb_MEE;
                        %             Knee_PercentMEEContribution = KneeMEE./WholeLimb_MEE;
                        %             Hip_PercentMEEContribution = HipMEE./WholeLimb_MEE;


                                MedGastroc_Rectified_HopS = MedGastroc_Rectified( :, s );
                                LatGastroc_Rectified_HopS = LatGastroc_Rectified( :, s );
                                Sol_Rectified_HopS = Sol_Rectified( :, s );
                                PL_Rectified_HopS = PL_Rectified( :, s );
                                TA_Rectified_HopS = TA_Rectified( :, s );


                                MedGastroc_HopS = MedGastroc( :, s );
                                LatGastroc_HopS = LatGastroc( :, s );
                                Sol_HopS = Sol( :, s );
                                PL_HopS = PL( :, s );
                                TA_HopS = TA( :, s );



                                Group_ID = repmat( m, numel(WholeLimb_Torque_HopS), 1);
                                Participant_ID = repmat( n, numel(WholeLimb_Torque_HopS), 1);
                                Limb_ID = repmat( a, numel(WholeLimb_Torque_HopS), 1);
                                Trial_ID = repmat( p, numel(WholeLimb_Torque_HopS), 1);
                                Hop_ID = repmat( s, numel(WholeLimb_Torque_HopS), 1);
                                HoppingRateID = repmat( HoppingRate_ID_forTable( b ), numel(WholeLimb_Torque_HopS), 1);
                                
                                

                                
                                
                                
                                
                                
                                
                                

                                TimeVector = (1 : numel(WholeLimb_Torque_HopS) ) ./ 300;



                                if m == 1 && a == 1 &&  p == 1 && s == 1

                                    TimeSeriesforR_ParticipantMean = [VGRF_Normalized_Downsampled_HopS,...
                                        AnkleAngle_HopS,  AnkleTorque_HopS,  AnklePower_HopS,...
                                        KneeAngle_HopS,  KneeTorque_HopS,  KneePower_HopS,...
                                        HipAngle_HopS,  HipTorque_HopS,  HipPower_HopS,...
                                        MedGastroc_Rectified_HopS,  LatGastroc_Rectified_HopS,  Sol_Rectified_HopS,  PL_Rectified_HopS,  TA_Rectified_HopS,...
                                        MedGastroc_HopS,  LatGastroc_HopS,  Sol_HopS,  PL_HopS,  TA_HopS,...
                                        Group_ID, Participant_ID ,Limb_ID, Trial_ID,Hop_ID, TimeVector', HoppingRateID];
                                        %Ankle_PercentMEEContribution,Knee_PercentMEEContribution,Hip_PercentMEEContribution,...

                                else

                                    TimeSeriesforR_ParticipantMean = [ TimeSeriesforR_ParticipantMean; VGRF_Normalized_Downsampled_HopS,...
                                        AnkleAngle_HopS,  AnkleTorque_HopS,  AnklePower_HopS,...
                                        KneeAngle_HopS,  KneeTorque_HopS,  KneePower_HopS,...
                                        HipAngle_HopS,  HipTorque_HopS,  HipPower_HopS,...
                                        MedGastroc_Rectified_HopS,  LatGastroc_Rectified_HopS,  Sol_Rectified_HopS,  PL_Rectified_HopS,  TA_Rectified_HopS,...
                                        MedGastroc_HopS,  LatGastroc_HopS,  Sol_HopS,  PL_HopS,  TA_HopS,...
                                        Group_ID, Participant_ID ,Limb_ID, Trial_ID,Hop_ID, TimeVector', HoppingRateID ];

                                end



                            end

                        end
                    
                    end%End B For Loop - Hopping Rate ID
                    
                end
                
            end
            
        end


    
    VariableNames = {'VGRF_Normalized_Downsampled','AnkleAngle','AnkleTorque','AnklePower',...
    'KneeAngle','KneeTorque','KneePower','HipAngle','HipTorque','HipPower',...
    'MedGastroc_Rectified','LatGastroc_Rectified','Sol_Rectified','PL_Rectified','TA_Rectified',...
    'MedGastroc_Normalized_NotDownsampled','LatGastroc_Normalized_NotDownsampled','Sol_Normalized','PL_Normalized_NotDownsampled','TA_Normalized_NotDownsampled','Group_ID', 'Participant_ID' ,'Limb_ID','Trial_ID','Hop_ID', 'TimeVector', 'HoppingRate_ID'};
%                 'Ankle_PercentMEEContribution','Knee_PercentMEEContribution',...
%                 'Hip_PercentMEEContribution',...


    TimeSeriesforR_ParticipantMean_Table = array2table(TimeSeriesforR_ParticipantMean,'VariableNames',VariableNames);

    writetable(TimeSeriesforR_ParticipantMean_Table, 'Hopping_InterGroupTimeSeries_ParticipantMeans_forR.xlsx' );
    
end



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 10',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end













%% SECTION 11 - Find Beginning of Ground Contact Phase - Use in Plots

for l = 1:numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});
        
%% M Loop - Run Once Per Group
    
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
            
            LimbID = {'LeftLimb','RightLimb'}; 
            
            RLimb_MuscleID = {'RMGastroc','RLGastroc','RSol','RPL','RTA'};
            
            HoppingRate_ID = { 'TwoHz', 'TwoPoint3Hz' };
            
        else
            
            ParticipantList = ControlParticipantList;
            
            ParticipantMass = ControlParticipantMass;
            
            LimbID = {'LeftLimb','RightLimb'};
            
            RLimb_MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                
            LLimb_MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
            
            HoppingRate_ID = { 'TwoPoint2Hz', 'TwoPoint3Hz' };
            
            
        end
        
        
        
        
        %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
        ParticipantNVariables_DataStructure = getfield(ParticipantListDataStructure,'AllParticipants');
        
        %Use get field to create a new data structure containing the list of categories under Individual Hops. Stored under the 4th field of the structure (the list of data categories)
        InterpolatedData_DataStructure = getfield(ParticipantNVariables_DataStructure,'InterpolatedData');

            
        
%% A For Loop - Run Once Per Limb
        for a = 1 : numel(LimbID)


                
                    
                %Use getfield to create a new data structure containing the data for Limb A
                ListofLimbIDs_DataStructure = getfield( ListofVariables_IndividualHops, LimbID{ a } );            
            
                %Use get field to create a new data structure containing the indexing data for
                %Limb A
                IndexingWthinLimbA_IndividualHops = getfield( ListofVariables_IndexingInParticipantN, LimbID{ a } );

                
                %Use get field to create a new data structure containing the data for Medial Gastroc
                 ListofVariables_MedGas = getfield( ListofLimbIDs_DataStructure, MuscleID{ 1 } );    

                

%% B For Loop - Run Once Per Hopping Rate


            for b = 1:numel(HoppingRate_ID)
                
                
                VGRF_Downsampled_OneHoppingRate = getfield(  ListofLimbIDs_DataStructure.V_GRF_DownSampled, HoppingRate_ID{b});
            
            
                BeginGContact_Table = [];
                BeginGContact = [];


                
                %LLimb_HoppingTrialNumbers = getfield(LimbIDDataStructure,LimbID{2});

                %Find the frame numbers corresponding to the beginning of the ground contact phase. Should
                %have one column per participant
                [BeginGContact, EndGContact] = CalculateBeginningAndEndOfHopCycle( VGRF_Downsampled_OneHoppingRate );

                %Should only have one BeginGContact value for each participant, but double check this.
                NRows_BeginGContact = size(BeginGContact);

                %Store participant numbers in the last row of BeginGContact
                BeginGContact(NRows_BeginGContact+1,:) = 1:numel(ParticipantList);

                %Store BeginGContact in data structure
                David_DissertationDataStructure = setfield(David_DissertationDataStructure,QualvsPostQualData{l},GroupList{m},'AllParticipants','InterpolatedData',LimbID{a},...
                            MTUID{n},'BeginGContact',BeginGContact);

                BeginGContact_Table = array2table(BeginGContact','VariableNames',{'Begin_GroundContact_FrameNumber','Participant_ID'}); 

                writetable(BeginGContact_Table,[GroupList{m}, '_' ,LimbID{a}, '_', HoppingRate_ID{b}, '_' , '_BeginGContactTable.xlsx' ] )
                
            end


        end
        
    end
    
end%End outer most For Loop





clearvars -except David_DissertationDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList DataCategories_HoppingKinematicsKinetics ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass CreateStruct

clc


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 11',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end
