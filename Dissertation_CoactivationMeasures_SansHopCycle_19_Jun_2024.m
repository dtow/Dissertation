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


%Want to clear the errors for the new section
lasterror = [];


%First field within data structure = data for quals versus for remainder of dissertation
QualvsPostQualData = {'Post_Quals'};
%Second field = group list
GroupList = {'ATx','Control'}; 
%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74', 'ATx65',...
    'ATx14' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC44', 'HC48', 'HC65' };
%4th field = data type
DataCategories_HoppingGRFandKin = {'HoppingKinematicsKinetics'};
DataCategories_HoppingKinematicsKineticss = {'HoppingKinematicsKinetics'};
DataCategories_IndividualHops = {'IndividualHops'};
%5th field = limb ID
LimbID = {'LeftLimb','RightLimb'};
%MuscleID = HoppingGRFandKin_Trial1.Properties.VariableNames;
RLimb_MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
LLimb_MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

%Specify sampling rates for GRF, EMG, kinematics/kinetics
GRFSampHz = 1500;
EMGSampHz = 1500;
MoCapSampHz = 300;

%Load the Mass data from the data structure
MassLog = David_DissertationDataStructure.Post_Quals.AllGroups.MassLog;

%Create vector containing the names of the downsampled vGRF variables
GRF_IDs = {'VGRF_Downsampled','VGRF_Normalized_Downsampled'};

%Create vector containing the different lower extremity joints
JointID = {'Ankle','Knee','Hip'};

%Create vector for pulling out sagittal plane data rather than frontal or transverse plane
PlaneID = {'Sagittal'};




%Load the Morphology data from the data structure
MorphologyLog = David_DissertationDataStructure.Post_Quals.AllGroups.MorphologyLog;

%Load the VAS data from the data structure
VASLog = David_DissertationDataStructure.Post_Quals.ATx.AllParticipants.VASLog;

    %Control Group
ControlVAS = 0;


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end





%% SECTION 3 - CALCULATE COACTIVATION MEASURES



%Want to clear the errors for the new section
lasterror = [];


%Use this to tell the code which row of TSContributiontoPFActivityParticipantMeans to fill
RowtoFill_CoactivationRatio_ParticipantMeans = 1;

%Use this to tell the code which row of AllTS_CoactivationRatio_RateMeans to fill
RowtoFill_CoactivationRatio_RateMeans = 1;


TSContributiontoPFActivityParticipantMeans = NaN(1, 93);

AllTS_CoactivationRatio_RateMeans = NaN(1, 93); 



    %Create a prompt so we can tell the code whether we've added any new participants
    ReprocessingDatPrompt =  'Are You Reprocessing Data?' ;

    %Use inputdlg function to create a dialogue box for the prompt created above.
    %First arg is prompt, 2nd is title
    ReprocessingData_Cell = inputdlg( [ '\fontsize{15}' ReprocessingDatPrompt ], 'Are You Reprocessing Data?', [1 150], {'No'} ,CreateStruct);



    %If we are NOT reprocessing data, access JointBehaviorIndex and Power_EntireContactPhase from the
    %data structure
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )

        %Save the AllTS_CoactivationRatio Tble in the data structure
        AllTS_CoactivationRatio = David_DissertationEMGDataStructure.Post_Quals.AllGroups.HoppingCoactivationRatio_Matrix;
        
        
        %RowtoFill for JointBehaviorIndex = current number of rows in JointBehaviorIndex
        RowtoFill_CoactivationRatio = size( AllTS_CoactivationRatio, 1) + 1;


    %If we ARE reprocessing data, initialize JointBehaviorIndex and Power_EntireContactPhase
    else
        
        %Initialize Tble to hold preactivation onset times
        AllTS_CoactivationRatio = NaN(1, 93);
        
        %Use this to tell the code which row of AllTS_CoactivationRatio to fill
        RowtoFill_CoactivationRatio = 1;
      
    end





    %If you are NOT reprocessing data, ask whether we have added any new participants
    if strcmp( cell2mat( ReprocessingData_Cell ), 'No' ) || strcmp( cell2mat( ReprocessingData_Cell ), 'N' )
    
        
        %Create a prompt so we can tell the code whether we've added any new participants
        AddedNewParticipantPrompt =  'Have You Added A New Participant?' ;
    
        %Use inputdlg function to create a dialogue box for the prompt created above.
        %First arg is prompt, 2nd is title
        AddedNewParticipant_Cell = inputdlg( [ '\fontsize{15}' AddedNewParticipantPrompt ], 'Have You Added A New Participant?', [1 150], {'Yes'} ,CreateStruct);


    %If you ARE reprocessing data, AddedParticipantNData_Cell is set to 'No' - automatically add each
    %participant's data to Tble for exporting
    else

       AddedParticipantNData_Cell = {'No'};

       AddedNewParticipant_Cell = {'No'};
    
    end





% Begin J For Loop - Create List of All Groups

for j = 1 : numel(QualvsPostQualData)
    
    ListofAllGroups = David_DissertationEMGDataStructure.( QualvsPostQualData{j} );


%% Begin K For Loop - Create List of All Participants Within A Given Group

    for k = 2% : numel( GroupList )
        
        ListofParticipants_GroupJ = ListofAllGroups.( GroupList{ k } );
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{ k }, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
           
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        
        
        
 %% Begin L For Loop - Create List of Variables within a Given Participant      
        
        for l = [ 1 : 13, 15 : 17 ]%1 : numel(ParticipantList)
            
            
            %If you are NOT reprocessing data, ask whether we have added any new participants
            if strcmp( cell2mat( AddedNewParticipant_Cell ), 'Yes' ) || strcmp( cell2mat( AddedNewParticipant_Cell ), 'Y' )
            
            
                %Create a prompt so we can tell the code whether we've added any new participants
                AddParticipantNDataPrompt = [ 'Have You Added ', ParticipantList{ l }, 's Data?' ];
                
                %Use inputdlg function to create a dialogue box for the prompt created above.
                %First arg is prompt, 2nd is title
                AddedParticipantNData_Cell = inputdlg( [ '\fontsize{15}' AddParticipantNDataPrompt ], [ 'Have You Added ', ParticipantList{ l }, 's Data?' ], [1 150], {'Yes'} ,CreateStruct);
            
            
            end



            
            
%% Set Limb ID, Hopping Rate ID            
            
            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %Tbles, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{ l }, 'ATx07'  ) || strcmp( ParticipantList{ l }, 'ATx08'  ) || strcmp( ParticipantList{ l }, 'ATx10'  ) || strcmp( ParticipantList{ l }, 'ATx17'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx18'  ) || strcmp( ParticipantList{ l }, 'ATx21'  ) || strcmp( ParticipantList{ l }, 'ATx25'  ) || strcmp( ParticipantList{ l }, 'ATx36'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx38'  ) || strcmp( ParticipantList{ l }, 'ATx39'  ) || strcmp( ParticipantList{ l }, 'ATx41'  ) || strcmp( ParticipantList{ l }, 'ATx49'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx74'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'ATx24'  )
                
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];




            elseif strcmp( ParticipantList{ l }, 'ATx19'  ) || strcmp( ParticipantList{ l }, 'ATx65'  )
             
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];



            elseif strcmp( ParticipantList{ l }, 'ATx12'  ) || strcmp( ParticipantList{ l }, 'ATx14'  ) || strcmp( ParticipantList{ l }, 'ATx27'  ) || strcmp( ParticipantList{ l }, 'ATx34'  ) || strcmp( ParticipantList{ l }, 'ATx44'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx50'  ) || strcmp( ParticipantList{ l }, 'ATx100'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ]; 
                
                



            elseif strcmp( ParticipantList{ l }, 'HC11'  ) || strcmp( ParticipantList{n}, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.33 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTble = [ 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'HC17'  ) || strcmp( ParticipantList{ l }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC32'  ) || strcmp( ParticipantList{ l }, 'HC34'  ) || strcmp( ParticipantList{ l }, 'HC45'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC48'  ) ||strcmp( ParticipantList{ l }, 'HC65'  ) || strcmp( ParticipantList{ l }, 'HC68'  )
                
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];


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
                 HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                               
            end
            
            
            
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ l }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ l }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
            
            
            
            
            
            ListofDataCategories_ParticipantL = ListofParticipants_GroupJ.( ParticipantList{l} );
            
            ListofVariables_IndividualHops = ListofDataCategories_ParticipantL.IndividualHops;
            
            ListofVariables_IndexingInParticipantL = ListofDataCategories_ParticipantL.UseforIndexingIntoData;

            
            
            
            
 %% Begin A For Loop - Create List of Variables for A Given Limb            
            
            for a = 1 : numel(LimbID)
            
                %Create a new data structure containing all the EMG data, split into individual hops
                ListofVariables_AthLimbEMG_IndividualHops = ListofVariables_IndividualHops.( LimbID{a} );

                

                %Create a new data structure containing all the EMG data - for MVIC and before
                %being split into individual hops. Will need this to access the summed integrated
                %EMG from the SLVJ reference contraction
                ListofEMGVariablesfromMVIC = ListofDataCategories_ParticipantL.HoppingEMG.( LimbID{a} );
                
                %Create a new data structure containing the indexing data for Limb A
                IndexingWthinLimbA_IndividualHops = ListofVariables_IndexingInParticipantL.( LimbID{a} );
                
                
                
%% Set Muscle IDs for Involved vs Non-Involved Limb                
                
                     %For ATx07, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                    if strcmp( ParticipantList{ l}, 'ATx07'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l}, 'ATx07'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l}, 'ATx08'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l}, 'ATx08'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                         
                     %For ATx10, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l}, 'ATx10'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx10 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        

                    %For ATx10, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx10'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx10 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx12'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx12'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx14 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx14, Non-Involved Limb is Right Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx14 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         

                     %For ATx17, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx17'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx17 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx17'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                         
                     %For ATx18, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx18'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx18 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx18'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                     
                        
                        
                    
                         
                         
                     %For ATx19, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx19'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx19'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                     %For ATx21, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx21'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx21'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         

                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx24'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx24'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx25'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx25'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx27'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx27'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx34'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx34'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx36'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx36'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx36 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx38'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx38'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx38 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx39'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx39'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{l}, 'ATx41'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{l}, 'ATx41'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx44'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx44'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx49'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx49'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx50 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx65'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx65 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx65, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx65'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx65 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx74'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx74'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                         

                    %LLGas for HC53 seems questionable. Don't include in the analysis     
                    elseif strcmp( ParticipantList{ l }, 'HC53'  ) && strcmp( LimbID{ a}, 'LeftLimb')

                        %Set the muscle ID list for HC53 left limb
                        MuscleID = {'LMGas','LSol','LPL','LTA'};
                         
                         
                         
                    %For the Control group, tell the code that the MuscleID should use 'R' in front
                    %of each muscle for the Right Limb
                    elseif strcmp(LimbID{ a },'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the Left Limb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                     end 
                     
                    
                    
                    %Pull out the summed integrated EMG from MSLVJ task - the one for reference
                    %contractions
                        %Entire task - both braking and propulsion phases
                    % SummedIntegratedEMG_SLVJ = getfield( ListofEMGVariablesfromMVIC, 'SumofIntegratedEMG_SLVJ' );

                        %Braking phase only
                    % SummedIntegratedEMG_SLVJ_BrakingPhase = getfield( ListofEMGVariablesfromMVIC,  'SumofIntegratedEMG_SLVJ_BrakingPhase' );

                        %Propulsion phase only
                    % SummedIntegratedEMG_SLVJ_PropulsionPhase = getfield( ListofEMGVariablesfromMVIC,  'SumofIntegratedEMG_SLVJ_PropulsionPhase' );

                    

%% Begin B For Loop - Hopping Rates                    
                    
                    for b = numel( HoppingRate_ID )
                    


                        
                        %Use get field to create a new data structure containing the kinematic and kinetic data for a given hopping rate. Stored under the 5th field of the structure (the list of MTUs)
                        IndexingWthinHoppingRateB = getfield( IndexingWthinLimbA_IndividualHops, HoppingRate_ID{b} );

                        %Find the length of the flight phase. There was an error in saving this data
                        %for the first 7 participants. All flight phases should be the same length.
                        %To fix this, find the minimum flight phase length. Then use repmat() to duplicate
                        %this length for the number of hops for this particular hopping rate
                        LengthofFlightPhase = IndexingWthinHoppingRateB.LengthofFlightPhase_Truncated_EMGSamplingHz;
                        
                        LengthofContactPhase_EMGSamplingHz = IndexingWthinHoppingRateB.LengthofContactPhase_EMGSamplingHz';                       
                        LengthofEntireHopCycle_EMGSamplingHz = IndexingWthinHoppingRateB.LengthofEntireHopCycle_Truncated_EMGSamplingHz';
                        
                        %Pull out the frame of the minimum L5-S1 marker vertical position - will use
                        %this to split the braking and propulsive phases
                        FrameofMinL5S1Position_EMGSampHz = IndexingWthinHoppingRateB.FrameofMinL5S1Position_EndBraking_EMGSampHz;
                        
                        
                        %Find length of contact phase in terms of MoCap Samp Hz. Need to convert
                        %LengthofContactPhase_EMGSamplingHz to seconds, then to MoCap frames
                        LengthofContactPhase_MoCapData = ( LengthofContactPhase_EMGSamplingHz ./ EMGSampHz ) .* MoCapSampHz;
                        
                        
                        
                        ListofGasMedVariables_LimbA = getfield( ListofVariables_AthLimbEMG_IndividualHops, MuscleID{ 1 } );

                        ListofGasLatVariables_LimbA = getfield( ListofVariables_AthLimbEMG_IndividualHops, MuscleID{ 2 } );

                        ListofSolVariables_LimbA = getfield( ListofVariables_AthLimbEMG_IndividualHops, MuscleID{ 3 } );

                        ListofPLVariables_LimbA = getfield( ListofVariables_AthLimbEMG_IndividualHops, MuscleID{ 4 } );

                        if ~strcmp( ParticipantList{ l }, 'ATx08'  )

                            ListofTAVariables_LimbA = getfield( ListofVariables_AthLimbEMG_IndividualHops, MuscleID{ 5 } );

                        end
                        
                        
                        HoppingTrialNumber = {'Trial1'};


                        
                        
                        
                        
                        
%% Initialize Variables that contain data for all hopping trials                 
                            
                     AllTSActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );                      
                    AllPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolandPLActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                    TSContributiontoPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolContributiontoPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );


                    AllTSActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );                      
                    AllPFActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolandPLActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    TSContributiontoPFActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolContributiontoPFActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );


                    AllTSActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );                      
                    AllPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolandPLActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    TSContributiontoPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                    MedGasandSolContributiontoPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );


                    AllTSActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasandSolActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasandSolandPLActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasandSolContributiontoPFActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasContributiontoAllTS_BrakingPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                    TAvsAllPF_CoactivationRatio_BrakingPhase = NaN( 1, numel( HoppingTrialNumber ) );        
                   AllPFActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                   TwoJointTSActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                   TSContributiontoPFActivity_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                   TwoJointTS_Contribution2AllPF_BrakingPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                   OneJointTS_Contribution2AllPF_BrakingPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                        
                    
                    AllTSActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasandSolActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasandSolandPLActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasandSolContributiontoPFActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    MedGasContributiontoAllTS_PropulsionPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                    TAvsAllPF_CoactivationRatio_PropulsionPhase = NaN( 1, numel( HoppingTrialNumber ) );   
                    AllPFActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    TwoJointTSActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                   TSContributiontoPFActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                    TwoJointTS_Contribution2AllPF_PropulsionPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                   OneJointTS_Contribution2AllPF_PropulsionPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                    
                   
             
                        
%% Begin N For loop - Hopping Trial Number         

                        for n = 1 : numel( HoppingTrialNumber )
    
                            

                            
                            %Set the time step between data points, in seconds, for integrating the EMG data
                            TimeInterval_forIntegratingEMG = 1./EMGSampHz;



                            

                            
%% Pull Out EMG from Data Structure                            
                            
                            ListofGasMedVariables_HoppingRateB = getfield( ListofGasMedVariables_LimbA, HoppingRate_ID{ b } );

                            ListofGasLatVariables_HoppingRateB = getfield( ListofGasLatVariables_LimbA, HoppingRate_ID{ b } );

                            ListofSolVariables_HoppingRateB = getfield( ListofSolVariables_LimbA, HoppingRate_ID{ b } );

                            ListofPLVariables_HoppingRateB = getfield( ListofPLVariables_LimbA, HoppingRate_ID{ b } );


                            if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                ListofTAVariables_HoppingRateB = getfield( ListofTAVariables_LimbA, HoppingRate_ID{ b } );          
                            end
                            
                            


                            %Create a data structure containing the ankle power data for the contact
                            %phase - data structure will contain list of all trials (bouts) of hopping
%                             AnklePower_TrialN = getfield( ListofPower_AthLimb_MthMTU, HoppingTrialNumber{ n } );
                            
                            

                            ListofGasMedVariables_LimbA_TrialN = getfield( ListofGasMedVariables_HoppingRateB, HoppingTrialNumber{ n } );

                            ListofGasLatVariables_LimbA_TrialN = getfield( ListofGasLatVariables_HoppingRateB, HoppingTrialNumber{ n } );

                            ListofSolVariables_LimbA_TrialN = getfield( ListofSolVariables_HoppingRateB, HoppingTrialNumber{ n } );

                            ListofPLVariables_LimbA_TrialN = getfield( ListofPLVariables_HoppingRateB, HoppingTrialNumber{ n } );


                            if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                ListofTAVariables_LimbA_TrialN = getfield( ListofTAVariables_HoppingRateB, HoppingTrialNumber{ n } );
                            end




                            GasMed_NormalizedEMG_LimbA_TrialN = ListofGasMedVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass;

                            GasLat_NormalizedEMG_LimbA_TrialN = ListofGasLatVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass;

                            Sol_NormalizedEMG_LimbA_TrialN = ListofSolVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass;

                            PL_NormalizedEMG_LimbA_TrialN = ListofPLVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass;


                            if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                TA_NormalizedEMG_LimbA_TrialN = ListofTAVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass;
                            end




                            GasMed_NormalizedEMG_ContactPhase_LimbA_TrialN = ListofGasMedVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass_ContactPhase;

                            GasLat_NormalizedEMG_ContactPhase_LimbA_TrialN = ListofGasLatVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass_ContactPhase;

                            Sol_NormalizedEMG_ContactPhase_LimbA_TrialN = ListofSolVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass_ContactPhase;

                            PL_NormalizedEMG_ContactPhase_LimbA_TrialN = ListofPLVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass_ContactPhase;


                            if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                TA_NormalizedEMG_ContactPhase_LimbA_TrialN = ListofTAVariables_LimbA_TrialN.NormalizedEMG_30HzBandpass_ContactPhase;
                            end





                            NumberofHops = size( GasMed_NormalizedEMG_LimbA_TrialN, 2 );




                            

%% Initialize Variables                    
        
        
                            %Initialize all variables holding MedGas integrated EMG
                            GasMed_IntegratedEMG = NaN( 3, NumberofHops  );
                            GasMed_IntegratedEMG_FlightPhase = NaN( 3, NumberofHops  );
                            GasMed_IntegratedEMG_ContactPhase = NaN( 3, NumberofHops  );
                            GasMed_IntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            GasMed_IntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );
                            GasMed_CumSumIntegratedEMG = NaN( NumberofHops, 1  );
                            GasMed_CumSumIntegratedEMG_FlightPhase = NaN( NumberofHops, 1  );
                            GasMed_CumSumIntegratedEMG_ContactPhase = NaN( NumberofHops, 1  );
                            GasMed_CumSumIntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            GasMed_CumSumIntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );

                            %Initialize all variables holding LatGas integrated EMG
                            GasLat_IntegratedEMG = NaN( 3, NumberofHops  );
                            GasLat_IntegratedEMG_FlightPhase = NaN( 3, NumberofHops  );
                            GasLat_IntegratedEMG_ContactPhase = NaN( 3, NumberofHops  );
                            GasLat_IntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            GasLat_IntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );
                            GasLat_CumSumIntegratedEMG = NaN( NumberofHops, 1  );
                            GasLat_CumSumIntegratedEMG_FlightPhase = NaN( NumberofHops, 1  );
                            GasLat_CumSumIntegratedEMG_ContactPhase = NaN( NumberofHops, 1  );
                            GasLat_CumSumIntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            GasLat_CumSumIntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );

                            
                            %Initialize all variables holding Sol integrated EMG
                            Sol_IntegratedEMG = NaN( 3, NumberofHops  );
                            Sol_IntegratedEMG_FlightPhase = NaN( 3, NumberofHops  );
                            Sol_IntegratedEMG_ContactPhase = NaN( 3, NumberofHops  );
                            Sol_IntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            Sol_IntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );
                            Sol_CumSumIntegratedEMG = NaN( NumberofHops, 1  );
                            Sol_CumSumIntegratedEMG_FlightPhase = NaN( NumberofHops, 1  );
                            Sol_CumSumIntegratedEMG_ContactPhase = NaN( NumberofHops, 1  );
                            Sol_CumSumIntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            Sol_CumSumIntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );

                            
                            %Initialize all variables holding PL integrated EMG
                            PL_IntegratedEMG = NaN( 3, NumberofHops  );
                            PL_IntegratedEMG_FlightPhase = NaN( 3, NumberofHops  );
                            PL_IntegratedEMG_ContactPhase = NaN( 3, NumberofHops  );
                            PL_IntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            PL_IntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );
                            PL_CumSumIntegratedEMG = NaN( NumberofHops, 1  );
                            PL_CumSumIntegratedEMG_FlightPhase = NaN( NumberofHops, 1  );
                            PL_CumSumIntegratedEMG_ContactPhase = NaN( NumberofHops, 1  );
                            PL_CumSumIntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            PL_CumSumIntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );

                            %Initialize all variables holding TA integrated EMG
                            TA_IntegratedEMG = NaN( 3, NumberofHops  );
                            TA_IntegratedEMG_FlightPhase = NaN( 3, NumberofHops  );
                            TA_IntegratedEMG_ContactPhase = NaN( 3, NumberofHops  );
                            TA_IntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            TA_IntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );
                            TA_CumSumIntegratedEMG = NaN( NumberofHops, 1  );
                            TA_CumSumIntegratedEMG_FlightPhase = NaN( NumberofHops, 1  );
                            TA_CumSumIntegratedEMG_ContactPhase = NaN( NumberofHops, 1  );
                            TA_CumSumIntegratedEMG_PropulsionPhase = NaN( 3, NumberofHops  );
                            TA_CumSumIntegratedEMG_BrakingPhase = NaN( 3, NumberofHops  );


                            %Initialize all variables holding contribution indices for the entire
                            %hop cycle
                            AllTSActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );                      
                            AllPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolandPLActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            TSContributiontoPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolContributiontoPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            TAvsAllPF_CoactivationRatio_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            TAvsAllbutLGas_CoactivationRatio_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            GastrocnemiiActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            GastrocnemiiContributiontoPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            SolContributiontoPFActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            SolContributiontoTSActivity_EntireHopCycle = NaN( 1, numel( HoppingTrialNumber ) );
                            

                            %Initialize all variables holding contribution indices for the flight
                            %phase
                            AllTSActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );                      
                            AllPFActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolandPLActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            TSContributiontoPFActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolContributiontoPFActivity_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            TAvsAllPF_CoactivationRatio_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            TAvsAllbutLGas_CoactivationRatio_FlightPhase = NaN( 1, numel( HoppingTrialNumber ) );


                            %Initialize all variables holding contribution indices for the ground
                            %contact phase
                            AllTSActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );                      
                            AllPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolandPLActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            TSContributiontoPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            MedGasandSolContributiontoPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            GastrocnemiiActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            GastrocnemiiContributiontoPFActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            SolContributiontoTSActivity_ContactPhase = NaN( 1, numel( HoppingTrialNumber ) );
                            TAvsAllPF_CoactivationRatio_ContactPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TAvsAllbutLGas_CoactivationRatio_ContactPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            SolContributiontoPFActivity_ContactPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            MedGasContributiontoTS_ContactPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            GastrocnemiiContributiontoTS_ContactPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            PFCoactivationRatio_HopvsMSLVJ =  NaN( 1, numel( HoppingTrialNumber ) ); 


                           %Initialize all variables holding contribution indices for braking and
                           %propulsion phases
                            MedGasContributiontoAllTS_BrakingPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                            TAvsAllPF_CoactivationRatio_BrakingPhase = NaN( 1, numel( HoppingTrialNumber ) ); 
                            SolContributiontoAllTS_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            SolContributiontoAllTS_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TwoJointTS_Contribution2TS_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TwoJointTS_Contribution2TS_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            AllTSActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            AllPFActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TwoJointTSActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TSContributiontoPFActivity_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TwoJointTS_Contribution2AllPF_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            OneJointTS_Contribution2AllPF_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            MedGasContributiontoAllTS_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            TAvsAllPF_CoactivationRatio_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            PFCoactivationRatio_HopvsMSLVJ_BrakingPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            PFCoactivationRatio_HopvsMSLVJ_PropulsionPhase =  NaN( 1, numel( HoppingTrialNumber ) ); 
                            
                            


% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for co-activation
% of all plantar flexors - for entire hop cycle, for flight phase, and for contact phase
                            ViggianiBarrett_PFCommonality = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFActivity = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFCoactivation = NaN( 3, NumberofHops  );

                            ViggianiBarrett_PFCommonality_FlightPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFActivity_FlightPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFCoactivation_FlightPhase = NaN( 3, NumberofHops  );

                            ViggianiBarrett_PFCommonality_ContactPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFActivity_ContactPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFCoactivation_ContactPhase = NaN( 3, NumberofHops  );


% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for co-activation
% dorsiflexors with all plantar flexors - for entire hop cycle, for flight phase, and for contact phase
                            ViggianiBarrett_DFPFCommonality = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFActivity = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFCoactivation = NaN( 3, NumberofHops  );

                            ViggianiBarrett_DFPFCommonality_FlightPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFActivity_FlightPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFCoactivation_FlightPhase = NaN( 3, NumberofHops  );

                            ViggianiBarrett_DFPFCommonality_ContactPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFActivity_ContactPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFCoactivation_ContactPhase = NaN( 3, NumberofHops  );

                            
% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for co-activation
% of all plantar flexors - for absorption and generation phases                           
                            ViggianiBarrett_PFCommonality_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFActivity_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFCoactivation_BrakingPhase = NaN( 3, NumberofHops  );
                            
                             ViggianiBarrett_PFCommonality_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFActivity_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_PFCoactivation_PropulsionPhase = NaN( 3, NumberofHops  );
                            
% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for contribution of
% GasMed to TS - for absorption and generation phases                                   
                            ViggianiBarrett_TSActivity_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_TSCoactivation_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_TSCommonality_BrakingPhase = NaN( 3, NumberofHops  );

                            ViggianiBarrett_TSActivity_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_TSCoactivation_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_TSCommonality_PropulsionPhase = NaN( 3, NumberofHops  );
                            
                            
% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for co-activation
% of dorsiflexors with all plantar flexors - for absorption and generation phases                                      
                            ViggianiBarrett_DFPFCommonality_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFActivity_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFCoactivation_BrakingPhase = NaN( 3, NumberofHops  );
                            
                            ViggianiBarrett_DFPFCommonality_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFActivity_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_DFPFCoactivation_PropulsionPhase = NaN( 3, NumberofHops  );
                            
                            
% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for co-activation
% of the two-joint TS with PL - for absorption and generation phases                                       
                             ViggianiBarrett_2JntTSCommonality_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_2JntTSActivity_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_2JntTSCoactivation_BrakingPhase = NaN( 3, NumberofHops  );
 
                              ViggianiBarrett_2JntTSCommonality_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_2JntTSActivity_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_2JntTSCoactivation_PropulsionPhase = NaN( 3, NumberofHops  );                           
                            
                            
                            
% Initialize Viggiani-Barrett Commonality, Activity, and Co-activation variables for co-activation
% of the one-joint TS with PL - for absorption and generation phases                                       
                             ViggianiBarrett_1JntTSCommonality_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_1JntTSActivity_BrakingPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_1JntTSCoactivation_BrakingPhase = NaN( 3, NumberofHops  );
 
                              ViggianiBarrett_1JntTSCommonality_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_1JntTSActivity_PropulsionPhase = NaN( 3, NumberofHops  );
                            ViggianiBarrett_1JntTSCoactivation_PropulsionPhase = NaN( 3, NumberofHops  );                                   
                            
                            
                            
                            
                            %Variables for holding length of power absorption and generation
                            %phases in EMG and MoCap Sampling Rates
                            MedGas_LengthofBrakingPhase_MoCapSampHz = NaN( NumberofHops, 1 );
                            LatGas_LengthofBrakingPhase_MoCapSampHz = NaN( NumberofHops, 1 );
                            Sol_LengthofBrakingPhase_MoCapSampHz = NaN( NumberofHops, 1 );
                            PL_LengthofBrakingPhase_MoCapSampHz = NaN( NumberofHops, 1 );
                            TA_LengthofBrakingPhase_MoCapSampHz = NaN( NumberofHops, 1 );
                            AnklePower_OthHop_LastFrameofBraking = NaN( NumberofHops, 1 );

                            MedGas_LengthofBrakingPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            MedGas_LastFrameofBraking_EMGSampHz = NaN( NumberofHops, 1 );
                            MedGas_LengthofPropulsionPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            MedGas_LengthofPropulsionPhase_MoCapSampHz = NaN( NumberofHops, 1 );

                            LatGas_LengthofBrakingPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            LatGas_LastFrameofBraking_EMGSampHz = NaN( NumberofHops, 1 );
                            LatGas_LengthofPropulsionPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            LatGas_LengthofPropulsionPhase_MoCapSampHz = NaN( NumberofHops, 1 );

                            Sol_LengthofBrakingPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            Sol_LastFrameofBraking_EMGSampHz = NaN( NumberofHops, 1 );
                            Sol_LengthofPropulsionPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            Sol_LengthofPropulsionPhase_MoCapSampHz = NaN( NumberofHops, 1 );

                            PL_LengthofBrakingPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            PL_LastFrameofBraking_EMGSampHz = NaN( NumberofHops, 1 );
                            PL_LengthofPropulsionPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            PL_LengthofPropulsionPhase_MoCapSampHz = NaN( NumberofHops, 1 );

                            TA_LengthofBrakingPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            TA_LastFrameofBraking_EMGSampHz = NaN( NumberofHops, 1 );
                            TA_LengthofPropulsionPhase_EMGSampHz = NaN( NumberofHops, 1 );
                            TA_LengthofPropulsionPhase_MoCapSampHz = NaN( NumberofHops, 1 );

                            
                            GasMed_BrakingPhase_AllHops = NaN( 3, NumberofHops );
                            GasLat_BrakingPhase_AllHops = NaN( 3, NumberofHops );
                            Sol_BrakingPhase_AllHops = NaN( 3, NumberofHops );
                            PL_BrakingPhase_AllHops = NaN( 3, NumberofHops );
                            TA_BrakingPhase_AllHops = NaN( 3, NumberofHops );
                            


                            GasMed_PropulsionPhase_AllHops = NaN( 3, NumberofHops );
                            GasLat_PropulsionPhase_AllHops = NaN( 3, NumberofHops );
                            Sol_PropulsionPhase_AllHops = NaN( 3, NumberofHops );
                            PL_PropulsionPhase_AllHops = NaN( 3, NumberofHops );
                            TA_PropulsionPhase_AllHops = NaN( 3, NumberofHops );

                            LengthofBrakingPhase = NaN( 1, NumberofHops );
                            LengthofPropulsionPhase_NonTruncated = NaN( 1, NumberofHops );

                            AllTSActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            AllPFActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            TwoJointTSActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            MedGasandSolActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            MedGasandSolandPLActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            TSContributiontoPFActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            MedGasandSolContributiontoPFActivity_BrakingPhase_Average = NaN( NumberofHops, 1);
                            TwoJointTS_Contribution2AllPF_BrakingPhase_Average = NaN( NumberofHops, 1);
                            OneJointTS_Contribution2AllPF_BrakingPhase_Average = NaN( NumberofHops, 1);
                            MedGasContributiontoAllTS_BrakingPhase_Average = NaN( NumberofHops, 1);
                            SolContributiontoAllTS_BrakingPhase_Average = NaN( NumberofHops, 1);
                            TwoJointTS_Contribution2TS_BrakingPhase_Average = NaN( NumberofHops, 1);
                            TAvsAllPF_CoactivationRatio_BrakingPhase_Average = NaN( NumberofHops, 1);
                            GasMed_AverageIntegratedEMG_BrakingPhase = NaN( NumberofHops, 1);
                            GasLat_AverageIntegratedEMG_BrakingPhase = NaN( NumberofHops, 1);
                            Sol_AverageIntegratedEMG_BrakingPhase = NaN( NumberofHops, 1);
                            PL_AverageIntegratedEMG_BrakingPhase = NaN( NumberofHops, 1);
                            TA_AverageIntegratedEMG_BrakingPhase = NaN( NumberofHops, 1);

                            AllTSActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            AllPFActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            TwoJointTSActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            MedGasandSolActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            MedGasandSolandPLActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            TSContributiontoPFActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            MedGasandSolContributiontoPFActivity_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            TwoJointTS_Contribution2AllPF_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            OneJointTS_Contribution2AllPF_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            MedGasContributiontoAllTS_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            SolContributiontoAllTS_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            TwoJointTS_Contribution2TS_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            TAvsAllPF_CoactivationRatio_PropulsionPhase_Average = NaN( NumberofHops, 1);
                            GasMed_AverageIntegratedEMG_PropulsionPhase = NaN( NumberofHops, 1);
                            GasLat_AverageIntegratedEMG_PropulsionPhase = NaN( NumberofHops, 1);
                            Sol_AverageIntegratedEMG_PropulsionPhase = NaN( NumberofHops, 1);
                            PL_AverageIntegratedEMG_PropulsionPhase = NaN( NumberofHops, 1);
                            TA_AverageIntegratedEMG_PropulsionPhase = NaN( NumberofHops, 1);


        %% Begin O For Loop - Run Once for Each Hop

                            for o = 1 : NumberofHops

%                                 %Pull out the ankle power data for a single hop
%                                 AnklePower_OthHop = AnklePower_TrialN( 1: LengthofContactPhase_MoCapData(o), o );
%                                 
%                                 %Find all negative values of the power data - these correspond to
%                                 %power absorption
%                                 BrakingPhaseIndices_MoCapSampHz = find( AnklePower_OthHop < 0 );                             
%                                 
%                                 %How many data points are there in the absorption phase?
%                                 LengthofBrakingPhase_MoCapSampHz(o) = numel( BrakingPhaseIndices_MoCapSampHz );
%                                 %Find the last frame of absorption phase
%                                 AnklePower_OthHop_LastFrameofBraking(o) = BrakingPhaseIndices_MoCapSampHz(end);
                                

%% Find Frames of Each Phase - Same Length for Each Muscle



                                FlightPhaseIndices = 1 : LengthofFlightPhase;

                                ContactPhaseIndices = ( LengthofFlightPhase + 1 ) : ( LengthofEntireHopCycle_EMGSamplingHz ( o ) );

                                BrakingPhaseIndices = round( 1 : FrameofMinL5S1Position_EMGSampHz ( o ) );

                                PropulsionPhaseIndices = round( ( FrameofMinL5S1Position_EMGSampHz ( o ) + 1 ) : ( numel(ContactPhaseIndices ) - 1 ) );
                                
                                BrakingPhaseLength = numel( BrakingPhaseIndices );

                                PropulsionPhaseLength = numel( PropulsionPhaseIndices );




%% Find EMG for Oth Hop, Entire Hop Cycle


                            GasMed_OthHop_EntireHop = GasMed_NormalizedEMG_LimbA_TrialN( 1 : LengthofEntireHopCycle_EMGSamplingHz( o ), o );
                            GasLat_OthHop_EntireHop = GasLat_NormalizedEMG_LimbA_TrialN( 1 : LengthofEntireHopCycle_EMGSamplingHz( o ), o );
                            Sol_OthHop_EntireHop = Sol_NormalizedEMG_LimbA_TrialN( 1 : LengthofEntireHopCycle_EMGSamplingHz( o ), o );
                            PL_OthHop_EntireHop = PL_NormalizedEMG_LimbA_TrialN( 1 : LengthofEntireHopCycle_EMGSamplingHz( o ), o );
                            if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                TA_OthHop_EntireHop = TA_NormalizedEMG_LimbA_TrialN( 1 : LengthofEntireHopCycle_EMGSamplingHz( o ), o );
                            end





%% Split EMG into Contact Phase - Same Length for Each Muscle




                                %Pull out the normalized EMG data for a single hop - this data
                                %corresponds to only the contact phase
                                GasMed_OthHop_ContactPhase = GasMed_NormalizedEMG_ContactPhase_LimbA_TrialN(  1 : LengthofContactPhase_EMGSamplingHz( o ), o );

                                GasLat_OthHop_ContactPhase = GasLat_NormalizedEMG_ContactPhase_LimbA_TrialN(  1 : LengthofContactPhase_EMGSamplingHz( o ) , o );

                                Sol_OthHop_ContactPhase = Sol_NormalizedEMG_ContactPhase_LimbA_TrialN(  1 : LengthofContactPhase_EMGSamplingHz( o ), o );

                                PL_OthHop_ContactPhase = PL_NormalizedEMG_ContactPhase_LimbA_TrialN(  1 : LengthofContactPhase_EMGSamplingHz( o ), o );


                                if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    TA_OthHop_ContactPhase = TA_NormalizedEMG_ContactPhase_LimbA_TrialN(  1 : LengthofContactPhase_EMGSamplingHz( o ), o );
                                end



                                


                                for p = 1 : LengthofEntireHopCycle_EMGSamplingHz ( o )


                                    GasMed_PthDataPoint = GasMed_OthHop_EntireHop(p);
                                    GasLat_PthDataPoint = GasLat_OthHop_EntireHop(p);
                                    Sol_PthDataPoint = Sol_OthHop_EntireHop(p);
                                    PL_PthDataPoint = PL_OthHop_EntireHop(p);

                                    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        TA_PthDataPoint = TA_OthHop_EntireHop(p);
                                    end



                                    GasMed_PthDataPoint_MaxOf1 = GasMed_PthDataPoint.*0.01;
                                    GasLat_PthDataPoint_MaxOf1 = GasLat_PthDataPoint.*0.01;
                                    Sol_PthDataPoint_MaxOf1 = Sol_PthDataPoint.*0.01;
                                    PL_PthDataPoint_MaxOf1 = PL_PthDataPoint.*0.01;

                                    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        TA_PthDataPoint_MaxOf1 = TA_PthDataPoint.*0.01;
                                    end

                                    

        %% Calculate Viggiani and Barrett Coactivation Measure                            

                                    AllPFMuscles_PthDataPoint = [ GasMed_PthDataPoint_MaxOf1, GasLat_PthDataPoint_MaxOf1, Sol_PthDataPoint_MaxOf1, PL_PthDataPoint_MaxOf1 ];

                                    MinimumPFMuscleActivity = min( AllPFMuscles_PthDataPoint );

                                    ViggianiBarrett_PFCommonality( p, o ) = ( numel(AllPFMuscles_PthDataPoint) .* MinimumPFMuscleActivity ) ./ sum( AllPFMuscles_PthDataPoint  );

                                    ViggianiBarrett_PFActivity( p, o ) = mean( AllPFMuscles_PthDataPoint );

                                    ViggianiBarrett_PFCoactivation( p, o ) = ( 0.5.*ViggianiBarrett_PFCommonality( p, o ) ) + ( 0.5.*ViggianiBarrett_PFActivity( p, o ) );






                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllDFPFMuscles_PthDataPoint = [ GasMed_PthDataPoint_MaxOf1, GasLat_PthDataPoint_MaxOf1, Sol_PthDataPoint_MaxOf1, PL_PthDataPoint_MaxOf1, TA_PthDataPoint_MaxOf1 ];
    
                                        MinimumDFPFMuscleActivity = min( AllDFPFMuscles_PthDataPoint );
    
                                        ViggianiBarrett_DFPFCommonality( p, o ) = ( numel(AllDFPFMuscles_PthDataPoint) .* MinimumDFPFMuscleActivity ) ./ sum( AllDFPFMuscles_PthDataPoint  );
    
                                        ViggianiBarrett_DFPFActivity( p, o ) = mean( AllDFPFMuscles_PthDataPoint );
    
                                        ViggianiBarrett_DFPFCoactivation( p, o ) = ( 0.5.*ViggianiBarrett_DFPFCommonality( p, o ) ) + ( 0.5.*ViggianiBarrett_DFPFActivity( p, o ) );
                                     end

                                end %End p for loop

                                



        %% For Loop - Integrated EMG During Contact Phase                           

                                for r = 1 : ( LengthofContactPhase_EMGSamplingHz( o )  )

                                    if r  == 1

                                        GasMed_IntegratedEMG_ContactPhase( r, o ) = 0;



                                    else

                                        GasMed_IntegratedEMG_ContactPhase( r, o ) = 0.5 .* ( ( GasMed_OthHop_ContactPhase(r) + GasMed_OthHop_ContactPhase(r-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end


                                end %End r loop




                                for r = 1 : LengthofContactPhase_EMGSamplingHz( o ) 

                                    if r  == 1

                                        GasLat_IntegratedEMG_ContactPhase( r, o ) = 0;


                                    else

                                        GasLat_IntegratedEMG_ContactPhase( r, o ) = 0.5 .* ( ( GasLat_OthHop_ContactPhase(r) + GasLat_OthHop_ContactPhase(r-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end


                                end %End r loop




                                for r = 1 : LengthofContactPhase_EMGSamplingHz( o ) 

                                    if r  == 1

                                        Sol_IntegratedEMG_ContactPhase( r, o ) = 0;


                                    else

                                        Sol_IntegratedEMG_ContactPhase( r, o ) = 0.5 .* ( ( Sol_OthHop_ContactPhase(r) + Sol_OthHop_ContactPhase(r-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end


                                end %End r loop




                                for r = 1 : LengthofContactPhase_EMGSamplingHz( o ) 

                                    if r  == 1

                                        PL_IntegratedEMG_ContactPhase( r, o ) = 0;


                                    else

                                        PL_IntegratedEMG_ContactPhase( r, o ) = 0.5 .* ( ( PL_OthHop_ContactPhase(r) + PL_OthHop_ContactPhase(r-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end


                                end %End r loop



                                if ~strcmp( ParticipantList{ l }, 'ATx08'  )

                                    for r = 1 : LengthofContactPhase_EMGSamplingHz( o ) 
    
                                        if r  == 1

                                            TA_IntegratedEMG_ContactPhase( r, o ) = 0;
                                             
    
    
                                        else

                                            TA_IntegratedEMG_ContactPhase( r, o ) = 0.5 .* ( ( TA_OthHop_ContactPhase(r) + TA_OthHop_ContactPhase(r-1) ) .* TimeInterval_forIntegratingEMG ) ;
                                             
    
                                        end
    
    
                                    end %End r loop

                                end


                                
                                
                                
                                
                                
                                
                                
%% For Loop - Integrated EMG During Absorption Phase                       



                                LengthofBrakingPhase( o ) = numel( BrakingPhaseIndices );
                                LengthofPropulsionPhase_NonTruncated( o ) = numel( PropulsionPhaseIndices );

                   

                                %Split EMG up into absorption and generation phases.
                                GasMed_OthHop_BrakingPhase = GasMed_OthHop_ContactPhase( BrakingPhaseIndices );
                                GasLat_OthHop_BrakingPhase = GasLat_OthHop_ContactPhase( BrakingPhaseIndices );
                                Sol_OthHop_BrakingPhase = Sol_OthHop_ContactPhase( BrakingPhaseIndices );
                                PL_OthHop_BrakingPhase = PL_OthHop_ContactPhase( BrakingPhaseIndices );
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    TA_OthHop_BrakingPhase = TA_OthHop_ContactPhase( BrakingPhaseIndices );
                                 end

                                GasMed_OthHop_PropulsionPhase = GasMed_OthHop_ContactPhase( PropulsionPhaseIndices );
                                GasLat_OthHop_PropulsionPhase = GasLat_OthHop_ContactPhase( PropulsionPhaseIndices );
                                Sol_OthHop_PropulsionPhase = Sol_OthHop_ContactPhase( PropulsionPhaseIndices );
                                PL_OthHop_PropulsionPhase = PL_OthHop_ContactPhase( PropulsionPhaseIndices );
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    TA_OthHop_PropulsionPhase = TA_OthHop_ContactPhase( PropulsionPhaseIndices );
                                 end



                                for p = 1 : LengthofBrakingPhase( o )

                                    if p == 1

                                        GasMed_IntegratedEMG_BrakingPhase( p, o ) = 0;

                                    else

                                        GasMed_IntegratedEMG_BrakingPhase( p, o ) = 0.5 .* ( ( GasMed_OthHop_BrakingPhase(p) + GasMed_OthHop_BrakingPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end

                                end



                                for p = 1 : LengthofBrakingPhase( o )

                                    if p == 1

                                        GasLat_IntegratedEMG_BrakingPhase( p, o ) = 0;

                                    else

                                        GasLat_IntegratedEMG_BrakingPhase( p, o ) = 0.5 .* ( ( GasLat_OthHop_BrakingPhase(p) + GasLat_OthHop_BrakingPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end

                                end



                                for p = 1 : LengthofBrakingPhase( o )

                                    if p == 1

                                        Sol_IntegratedEMG_BrakingPhase( p, o ) = 0;

                                    else

                                        Sol_IntegratedEMG_BrakingPhase( p, o ) = 0.5 .* ( ( Sol_OthHop_BrakingPhase(p) + Sol_OthHop_BrakingPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end

                                end



                                for p = 1 : LengthofBrakingPhase( o )

                                    if p == 1

                                        PL_IntegratedEMG_BrakingPhase( p, o ) = 0;

                                    else

                                        PL_IntegratedEMG_BrakingPhase( p, o ) = 0.5 .* ( ( PL_OthHop_BrakingPhase(p) + PL_OthHop_BrakingPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end

                                end



                                if ~strcmp( ParticipantList{ l }, 'ATx08'  )

                                    for p = 1 : LengthofBrakingPhase( o )
    
                                        if p == 1
    
                                             
                                            TA_IntegratedEMG_BrakingPhase( p, o ) = 0;
    
                                        else
    
                                            TA_IntegratedEMG_BrakingPhase( p, o ) = 0.5 .* ( ( TA_OthHop_BrakingPhase(p) + TA_OthHop_BrakingPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;
                                            
    
                                        end
    
                                    end

                                end

                                    


                                    

                                for p = 1 : numel( GasMed_OthHop_BrakingPhase )


                                    GasMed_PthDataPoint_BrakingPhase = GasMed_OthHop_BrakingPhase(p);
                                    GasLat_PthDataPoint_BrakingPhase = GasLat_OthHop_BrakingPhase(p);
                                    Sol_PthDataPoint_BrakingPhase = Sol_OthHop_BrakingPhase(p);
                                    PL_PthDataPoint_BrakingPhase = PL_OthHop_BrakingPhase(p);
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        TA_PthDataPoint_BrakingPhase = TA_OthHop_BrakingPhase(p);
                                     end



                                    GasMed_PthDataPoint_BrakingPhase_MaxOf1 = GasMed_PthDataPoint_BrakingPhase.*0.01;
                                    GasLat_PthDataPoint_BrakingPhase_MaxOf1 = GasLat_PthDataPoint_BrakingPhase.*0.01;
                                    Sol_PthDataPoint_BrakingPhase_MaxOf1 = Sol_PthDataPoint_BrakingPhase.*0.01;
                                    PL_PthDataPoint_BrakingPhase_MaxOf1 = PL_PthDataPoint_BrakingPhase.*0.01;
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        TA_PthDataPoint_BrakingPhase_MaxOf1 = TA_PthDataPoint_BrakingPhase.*0.01;
                                     end
                                    
                                    
                                    

%% Calculate Viggiani and Barrett Coactivation Measure for ABSORPTION PHASE                    


  %Calculate Viggiani-Barrett Coactivation between the ALL PF
                                    AllPFMuscles_PthDataPoint_BrakingPhase = [ GasMed_PthDataPoint_BrakingPhase_MaxOf1, GasLat_PthDataPoint_BrakingPhase_MaxOf1, Sol_PthDataPoint_BrakingPhase_MaxOf1, PL_PthDataPoint_BrakingPhase_MaxOf1 ];

                                    MinimumPFMuscleActivity_BrakingPhase = min( AllPFMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_PFCommonality_BrakingPhase( p, o ) = ( numel(AllPFMuscles_PthDataPoint_BrakingPhase) .* MinimumPFMuscleActivity_BrakingPhase ) ./ sum( AllPFMuscles_PthDataPoint_BrakingPhase  );

                                    ViggianiBarrett_PFActivity_BrakingPhase( p, o ) = mean( AllPFMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_PFCoactivation_BrakingPhase( p, o ) = ( 0.5.*ViggianiBarrett_PFCommonality_BrakingPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_PFActivity_BrakingPhase( p, o ) );

                                    
                                    
                                    
                                    
   %Calculate Viggiani-Barrett Coactivation between ALL TS                            
                                    AllTSMuscles_PthDataPoint_BrakingPhase = [ GasMed_PthDataPoint_BrakingPhase_MaxOf1, GasLat_PthDataPoint_BrakingPhase_MaxOf1, Sol_PthDataPoint_BrakingPhase_MaxOf1 ];

                                    MinimumTSMuscleActivity_BrakingPhase = min( AllTSMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_TSCommonality_BrakingPhase( p, o ) = ( numel(AllTSMuscles_PthDataPoint_BrakingPhase) .* MinimumTSMuscleActivity_BrakingPhase ) ./ sum( AllTSMuscles_PthDataPoint_BrakingPhase  );

                                    ViggianiBarrett_TSActivity_BrakingPhase( p, o ) = mean( AllTSMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_TSCoactivation_BrakingPhase( p, o ) = ( 0.5.*ViggianiBarrett_TSCommonality_BrakingPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_TSActivity_BrakingPhase( p, o ) );




  %Calculate Viggiani-Barrett Coactivation between the DF and PF
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllDFPFMuscles_PthDataPoint_BrakingPhase = [ GasMed_PthDataPoint_BrakingPhase_MaxOf1, GasLat_PthDataPoint_BrakingPhase_MaxOf1, Sol_PthDataPoint_BrakingPhase_MaxOf1, PL_PthDataPoint_BrakingPhase_MaxOf1, TA_PthDataPoint_BrakingPhase_MaxOf1 ];
    
                                        MinimumDFPFMuscleActivity_BrakingPhase = min( AllDFPFMuscles_PthDataPoint_BrakingPhase );
    
                                        ViggianiBarrett_DFPFCommonality_BrakingPhase( p, o ) = ( numel(AllDFPFMuscles_PthDataPoint_BrakingPhase) .* MinimumDFPFMuscleActivity_BrakingPhase ) ./ sum( AllDFPFMuscles_PthDataPoint_BrakingPhase  );
    
                                        ViggianiBarrett_DFPFActivity_BrakingPhase( p, o ) = mean( AllDFPFMuscles_PthDataPoint_BrakingPhase );
    
                                        ViggianiBarrett_DFPFCoactivation_BrakingPhase( p, o ) = ( 0.5.*ViggianiBarrett_DFPFCommonality_BrakingPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_DFPFActivity_BrakingPhase( p, o ) );
                                     end
                                    
                                    
  %Calculate Viggiani-Barrett Coactivation between the two-joint TS and PL
                                     TwoJointTSMuscles_PthDataPoint_BrakingPhase = [ GasMed_PthDataPoint_BrakingPhase_MaxOf1, GasLat_PthDataPoint_BrakingPhase_MaxOf1, PL_PthDataPoint_BrakingPhase_MaxOf1 ];

                                    MinimumTwoJointTSMuscleActivity_BrakingPhase = min( TwoJointTSMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_2JntTSCommonality_BrakingPhase( p, o ) = ( numel(TwoJointTSMuscles_PthDataPoint_BrakingPhase) .* MinimumTwoJointTSMuscleActivity_BrakingPhase ) ./ sum( TwoJointTSMuscles_PthDataPoint_BrakingPhase  );

                                    ViggianiBarrett_2JntTSActivity_BrakingPhase( p, o ) = mean( TwoJointTSMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_2JntTSCoactivation_BrakingPhase( p, o ) = ( 0.5.*ViggianiBarrett_2JntTSCommonality_BrakingPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_2JntTSActivity_BrakingPhase( p, o ) );                                   
                                    
                                    
  %Calculate Viggiani-Barrett Coactivation between the one-joint TS and PL
                                      OneJointTSMuscles_PthDataPoint_BrakingPhase = [ Sol_PthDataPoint_BrakingPhase_MaxOf1, PL_PthDataPoint_BrakingPhase_MaxOf1 ];

                                    MinimumOneJointTSMuscleActivity_BrakingPhase = min( OneJointTSMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_1JntTSCommonality_BrakingPhase( p, o ) = ( numel(OneJointTSMuscles_PthDataPoint_BrakingPhase) .* MinimumOneJointTSMuscleActivity_BrakingPhase ) ./ sum( OneJointTSMuscles_PthDataPoint_BrakingPhase  );

                                    ViggianiBarrett_1JntTSActivity_BrakingPhase( p, o ) = mean( OneJointTSMuscles_PthDataPoint_BrakingPhase );

                                    ViggianiBarrett_1JntTSCoactivation_BrakingPhase( p, o ) = ( 0.5.*ViggianiBarrett_1JntTSCommonality_BrakingPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_1JntTSActivity_BrakingPhase( p, o ) );                                   
                                                                       
                                    
                                    
                                end %End p for loop                                
                                
                                
                                
                                
                                
                                
                                

%% For Loop - Integrated EMG During Generation Phase                       

                                for p = 1 : LengthofPropulsionPhase_NonTruncated( o )

                                    if p == 1

                                        GasMed_IntegratedEMG_PropulsionPhase( p, o ) = 0;

                                    else

                                        GasMed_IntegratedEMG_PropulsionPhase( p, o ) = 0.5 .* ( ( GasMed_OthHop_PropulsionPhase(p) + GasMed_OthHop_PropulsionPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;


                                    end

                                end



                                for p = 1 : LengthofPropulsionPhase_NonTruncated( o ) - 1

                                    if p == 1

                                        GasLat_IntegratedEMG_PropulsionPhase( p, o ) = 0;

                                    else

                                        GasLat_IntegratedEMG_PropulsionPhase( p, o ) = 0.5 .* ( ( GasLat_OthHop_PropulsionPhase(p) + GasLat_OthHop_PropulsionPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;

                                    end

                                end


                                for p = 1 : LengthofPropulsionPhase_NonTruncated( o ) - 1

                                    if p == 1

                                        Sol_IntegratedEMG_PropulsionPhase( p, o ) = 0;


                                    else

                                        Sol_IntegratedEMG_PropulsionPhase( p, o ) = 0.5 .* ( ( Sol_OthHop_PropulsionPhase(p) + Sol_OthHop_PropulsionPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;


                                    end

                                end



                                for p = 1 : LengthofPropulsionPhase_NonTruncated( o ) - 1

                                    if p == 1

                                        PL_IntegratedEMG_PropulsionPhase( p, o ) = 0;

                                    else

                                        PL_IntegratedEMG_PropulsionPhase( p, o ) = 0.5 .* ( ( PL_OthHop_PropulsionPhase(p) + PL_OthHop_PropulsionPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;


                                    end

                                end


                                if ~strcmp( ParticipantList{ l }, 'ATx08'  )

                                    for p = 1 : LengthofPropulsionPhase_NonTruncated( o ) - 1
    
                                        if p == 1
    
                                            TA_IntegratedEMG_PropulsionPhase( p, o ) = 0;
    
                                        else

                                            TA_IntegratedEMG_PropulsionPhase( p, o ) = 0.5 .* ( ( TA_OthHop_PropulsionPhase(p) + TA_OthHop_PropulsionPhase(p-1) ) .* TimeInterval_forIntegratingEMG ) ;
                                            
    
                                        end
    
                                    end

                                end




                                    

                                for p = 1 : numel( GasMed_OthHop_PropulsionPhase )

                                    GasMed_PthDataPoint_PropulsionPhase = GasMed_OthHop_PropulsionPhase(p);
                                    GasLat_PthDataPoint_PropulsionPhase = GasLat_OthHop_PropulsionPhase(p);
                                    Sol_PthDataPoint_PropulsionPhase = Sol_OthHop_PropulsionPhase(p);
                                    PL_PthDataPoint_PropulsionPhase = PL_OthHop_PropulsionPhase(p);
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        TA_PthDataPoint_PropulsionPhase = TA_OthHop_PropulsionPhase(p);
                                     end



                                    GasMed_PthDataPoint_PropulsionPhase_MaxOf1 = GasMed_PthDataPoint_PropulsionPhase.*0.01;
                                    GasLat_PthDataPoint_PropulsionPhase_MaxOf1 = GasLat_PthDataPoint_PropulsionPhase.*0.01;
                                    Sol_PthDataPoint_PropulsionPhase_MaxOf1 = Sol_PthDataPoint_PropulsionPhase.*0.01;
                                    PL_PthDataPoint_PropulsionPhase_MaxOf1 = PL_PthDataPoint_PropulsionPhase.*0.01;
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                         TA_PthDataPoint_PropulsionPhase_MaxOf1 = TA_PthDataPoint_PropulsionPhase.*0.01;
                                     end

                                    
                                    
                                    
        %% Calculate Viggiani and Barrett Coactivation Measure                            

                                    AllPFMuscles_PthDataPoint_PropulsionPhase = [ GasMed_PthDataPoint_PropulsionPhase_MaxOf1, GasLat_PthDataPoint_PropulsionPhase_MaxOf1, Sol_PthDataPoint_PropulsionPhase_MaxOf1, PL_PthDataPoint_PropulsionPhase_MaxOf1 ];

                                    MinimumPFMuscleActivity_PropulsionPhase = min( AllPFMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_PFCommonality_PropulsionPhase( p, o ) = ( numel(AllPFMuscles_PthDataPoint_PropulsionPhase) .* MinimumPFMuscleActivity_PropulsionPhase ) ./ sum( AllPFMuscles_PthDataPoint_PropulsionPhase  );

                                    ViggianiBarrett_PFActivity_PropulsionPhase( p, o ) = mean( AllPFMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_PFCoactivation_PropulsionPhase( p, o ) = ( 0.5.*ViggianiBarrett_PFCommonality_PropulsionPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_PFActivity_PropulsionPhase( p, o ) );

                                    
                                    
                                    
                                    
                                    
                                    AllTSMuscles_PthDataPoint_PropulsionPhase = [ GasMed_PthDataPoint_PropulsionPhase_MaxOf1, GasLat_PthDataPoint_PropulsionPhase_MaxOf1, Sol_PthDataPoint_PropulsionPhase_MaxOf1 ];

                                    MinimumTSMuscleActivity_PropulsionPhase = min( AllTSMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_TSCommonality_PropulsionPhase( p, o ) = ( numel(AllTSMuscles_PthDataPoint_PropulsionPhase) .* MinimumTSMuscleActivity_PropulsionPhase ) ./ sum( AllTSMuscles_PthDataPoint_PropulsionPhase  );

                                    ViggianiBarrett_TSActivity_PropulsionPhase( p, o ) = mean( AllTSMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_TSCoactivation_PropulsionPhase( p, o ) = ( 0.5.*ViggianiBarrett_TSCommonality_PropulsionPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_TSActivity_PropulsionPhase( p, o ) );





                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllDFPFMuscles_PthDataPoint_PropulsionPhase = [ GasMed_PthDataPoint_PropulsionPhase_MaxOf1, GasLat_PthDataPoint_PropulsionPhase_MaxOf1, Sol_PthDataPoint_PropulsionPhase_MaxOf1, PL_PthDataPoint_PropulsionPhase_MaxOf1, TA_PthDataPoint_PropulsionPhase_MaxOf1 ];
    
                                        MinimumDFPFMuscleActivity_PropulsionPhase = min( AllDFPFMuscles_PthDataPoint_PropulsionPhase );
    
                                        ViggianiBarrett_DFPFCommonality_PropulsionPhase( p, o ) = ( numel(AllDFPFMuscles_PthDataPoint_PropulsionPhase) .* MinimumDFPFMuscleActivity_PropulsionPhase ) ./ sum( AllDFPFMuscles_PthDataPoint_PropulsionPhase  );
    
                                        ViggianiBarrett_DFPFActivity_PropulsionPhase( p, o ) = mean( AllDFPFMuscles_PthDataPoint_PropulsionPhase );
    
                                        ViggianiBarrett_DFPFCoactivation_PropulsionPhase( p, o ) = ( 0.5.*ViggianiBarrett_DFPFCommonality_PropulsionPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_DFPFActivity_PropulsionPhase( p, o ) );
                                     end
                                    
                                    
    %Calculate Viggiani-Barrett Coactivation between the two-joint TS and PL
                                     TwoJointTSMuscles_PthDataPoint_PropulsionPhase = [ GasMed_PthDataPoint_PropulsionPhase_MaxOf1, GasLat_PthDataPoint_PropulsionPhase_MaxOf1, PL_PthDataPoint_PropulsionPhase_MaxOf1 ];

                                    MinimumTwoJointTSMuscleActivity_PropulsionPhase = min( TwoJointTSMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_2JntTSCommonality_PropulsionPhase( p, o ) = ( numel(TwoJointTSMuscles_PthDataPoint_PropulsionPhase) .* MinimumTwoJointTSMuscleActivity_PropulsionPhase ) ./ sum( TwoJointTSMuscles_PthDataPoint_PropulsionPhase  );

                                    ViggianiBarrett_2JntTSActivity_PropulsionPhase( p, o ) = mean( TwoJointTSMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_2JntTSCoactivation_PropulsionPhase( p, o ) = ( 0.5.*ViggianiBarrett_2JntTSCommonality_PropulsionPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_2JntTSActivity_PropulsionPhase( p, o ) );                                   
                                    
                                    
  %Calculate Viggiani-Barrett Coactivation between the one-joint TS and PL
                                      OneJointTSMuscles_PthDataPoint_PropulsionPhase = [ Sol_PthDataPoint_PropulsionPhase_MaxOf1, PL_PthDataPoint_PropulsionPhase_MaxOf1 ];

                                    MinimumOneJointTSMuscleActivity_PropulsionPhase = min( OneJointTSMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_1JntTSCommonality_PropulsionPhase( p, o ) = ( numel(OneJointTSMuscles_PthDataPoint_PropulsionPhase) .* MinimumOneJointTSMuscleActivity_PropulsionPhase ) ./ sum( OneJointTSMuscles_PthDataPoint_PropulsionPhase  );

                                    ViggianiBarrett_1JntTSActivity_PropulsionPhase( p, o ) = mean( OneJointTSMuscles_PthDataPoint_PropulsionPhase );

                                    ViggianiBarrett_1JntTSCoactivation_PropulsionPhase( p, o ) = ( 0.5.*ViggianiBarrett_1JntTSCommonality_PropulsionPhase( p, o ) ) + ( 0.5.*ViggianiBarrett_1JntTSActivity_PropulsionPhase( p, o ) );                                   
                                                                                                         
                                    
                                    
                                    
                                end %End p for loop                                    
                                


                                

%Find the cumulative sum of all integrated EMG values for the contact phase - do this for each muscle      
                                GasMed_CumSumIntegratedEMG_ContactPhase( o ) = sum( GasMed_IntegratedEMG_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o )-1, o ) ) ;

                                GasLat_CumSumIntegratedEMG_ContactPhase( o ) = sum( GasLat_IntegratedEMG_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o )-1, o ) ) ;

                                Sol_CumSumIntegratedEMG_ContactPhase( o ) = sum( Sol_IntegratedEMG_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o )-1, o ) ) ;

                                PL_CumSumIntegratedEMG_ContactPhase( o ) = sum( PL_IntegratedEMG_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o )-1, o ) ) ;

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                     TA_CumSumIntegratedEMG_ContactPhase( o, n ) = sum( TA_IntegratedEMG_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o )-1, o ) ) ;
                                 end
                                
                                
%Find the cumulative sum of all integrated EMG values for the generation phase - do this for each muscle                                      
                                GasMed_CumSumIntegratedEMG_PropulsionPhase( o ) = sum( GasMed_IntegratedEMG_PropulsionPhase( 1 :  LengthofPropulsionPhase_NonTruncated( o ), o ) ) ;

                                GasLat_CumSumIntegratedEMG_PropulsionPhase( o ) = sum( GasLat_IntegratedEMG_PropulsionPhase( 1 : LengthofPropulsionPhase_NonTruncated( o )-1, o ) ) ;

                                Sol_CumSumIntegratedEMG_PropulsionPhase( o ) = sum( Sol_IntegratedEMG_PropulsionPhase( 1 :  LengthofPropulsionPhase_NonTruncated( o )-1, o ) ) ;

                                PL_CumSumIntegratedEMG_PropulsionPhase( o ) = sum( PL_IntegratedEMG_PropulsionPhase( 1 :  LengthofPropulsionPhase_NonTruncated( o )-1, o ) ) ;

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    TA_CumSumIntegratedEMG_PropulsionPhase( o, n ) = sum( TA_IntegratedEMG_PropulsionPhase( 1 :  LengthofPropulsionPhase_NonTruncated( o )-1, o ) ) ;                                
                                 end
                                




                                %Calculate average MedGas EMG for braking phase. Divide cum sum of
                                %integrated EMG by length of braking phase
                                GasMed_CumSumIntegratedEMG_BrakingPhase( o ) = sum( GasMed_IntegratedEMG_BrakingPhase( 1 : LengthofBrakingPhase( o ), o ) ) ;

                                GasLat_CumSumIntegratedEMG_BrakingPhase( o ) = sum( GasLat_IntegratedEMG_BrakingPhase( 1 : LengthofBrakingPhase( o ), o ) ) ;

                                Sol_CumSumIntegratedEMG_BrakingPhase( o ) = sum( Sol_IntegratedEMG_BrakingPhase( 1 : LengthofBrakingPhase( o ), o ) ) ;

                                PL_CumSumIntegratedEMG_BrakingPhase( o ) = sum( PL_IntegratedEMG_BrakingPhase( 1 : LengthofBrakingPhase( o ), o ) ) ;

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    TA_CumSumIntegratedEMG_BrakingPhase( o, n ) = sum( TA_IntegratedEMG_BrakingPhase( 1 : LengthofBrakingPhase( o ), o ) ) ;                                
                                 end
                                
                                

                                

                                %Calculate average MedGas EMG for braking phase. Divide cum sum of
                                %integrated EMG by length of braking phase
                                GasMed_AverageIntegratedEMG_BrakingPhase( o ) = GasMed_CumSumIntegratedEMG_BrakingPhase( o ) ./ ( LengthofBrakingPhase( o ) ./ EMGSampHz );

                                %Calculate average LatGas EMG for braking phase. Divide cum sum of
                                %integrated EMG by length of braking phase
                                GasLat_AverageIntegratedEMG_BrakingPhase( o ) = GasLat_CumSumIntegratedEMG_BrakingPhase( o ) ./ ( LengthofBrakingPhase( o ) ./ EMGSampHz );

                                %Calculate average Sol EMG for braking phase. Divide cum sum of
                                %integrated EMG by length of braking phase
                                Sol_AverageIntegratedEMG_BrakingPhase( o ) = Sol_CumSumIntegratedEMG_BrakingPhase( o ) ./ ( LengthofBrakingPhase( o ) ./ EMGSampHz );

                                %Calculate average PL EMG for braking phase. Divide cum sum of
                                %integrated EMG by length of braking phase
                                PL_AverageIntegratedEMG_BrakingPhase( o ) = PL_CumSumIntegratedEMG_BrakingPhase( o ) ./ ( LengthofBrakingPhase( o ) ./ EMGSampHz );

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Calculate average TA EMG for braking phase. Divide cum sum of
                                    %integrated EMG by length of braking phase
                                    TA_AverageIntegratedEMG_BrakingPhase( o ) = TA_CumSumIntegratedEMG_BrakingPhase( o ) ./ ( LengthofBrakingPhase( o ) ./ EMGSampHz );
                                 end



                                %Calculate average MedGas EMG for Propulsion phase. Divide cum sum of
                                %integrated EMG by length of Propulsion phase
                                GasMed_AverageIntegratedEMG_PropulsionPhase( o ) = GasMed_CumSumIntegratedEMG_PropulsionPhase( o ) ./ ( LengthofPropulsionPhase_NonTruncated( o ) ./ EMGSampHz );

                                %Calculate average LatGas EMG for Propulsion phase. Divide cum sum of
                                %integrated EMG by length of Propulsion phase
                                GasLat_AverageIntegratedEMG_PropulsionPhase( o ) = GasLat_CumSumIntegratedEMG_PropulsionPhase( o ) ./ ( LengthofPropulsionPhase_NonTruncated( o ) ./ EMGSampHz );

                                %Calculate average Sol EMG for Propulsion phase. Divide cum sum of
                                %integrated EMG by length of Propulsion phase
                                Sol_AverageIntegratedEMG_PropulsionPhase( o ) = Sol_CumSumIntegratedEMG_PropulsionPhase( o ) ./ ( LengthofPropulsionPhase_NonTruncated( o ) ./ EMGSampHz );

                                %Calculate average PL EMG for Propulsion phase. Divide cum sum of
                                %integrated EMG by length of Propulsion phase
                                PL_AverageIntegratedEMG_PropulsionPhase( o ) = PL_CumSumIntegratedEMG_PropulsionPhase( o ) ./ ( LengthofPropulsionPhase_NonTruncated( o ) ./ EMGSampHz );

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Calculate average TA EMG for Propulsion phase. Divide cum sum of
                                    %integrated EMG by length of Propulsion phase
                                    TA_AverageIntegratedEMG_PropulsionPhase( o ) = TA_CumSumIntegratedEMG_PropulsionPhase( o ) ./ ( LengthofPropulsionPhase_NonTruncated( o ) ./ EMGSampHz );
                                 end

                                

%Find the data points in ViggianiBarrett_PFCommonality, Activity, and Coactivation that correspond
%to flight phase only
                                ViggianiBarrett_PFCommonality_FlightPhase( 1 : LengthofFlightPhase , o ) = ViggianiBarrett_PFCommonality(  1 : LengthofFlightPhase , o );

                                ViggianiBarrett_PFActivity_FlightPhase( 1 : LengthofFlightPhase , o ) = ViggianiBarrett_PFActivity(  1 : LengthofFlightPhase , o );

                                ViggianiBarrett_PFCoactivation_FlightPhase( 1 : LengthofFlightPhase , o ) = ViggianiBarrett_PFCoactivation(  1 : LengthofFlightPhase , o );



%Find the data points in ViggianiBarrett_PFCommonality, Activity, and Coactivation that correspond
%to contact phase only. Since contact phase begins one frame after end of flight phase, can simply
%add 1 to LengthofFlightPhase
                                ViggianiBarrett_PFCommonality_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o ), o ) = ViggianiBarrett_PFCommonality( ( LengthofFlightPhase  + 1 ) : ( LengthofFlightPhase + LengthofContactPhase_EMGSamplingHz( o ) ), o );

                                ViggianiBarrett_PFActivity_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o ), o ) = ViggianiBarrett_PFActivity(  ( LengthofFlightPhase  + 1 ) : ( LengthofFlightPhase + LengthofContactPhase_EMGSamplingHz( o ) ), o );

                                ViggianiBarrett_PFCoactivation_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o ), o ) = ViggianiBarrett_PFCoactivation(  ( LengthofFlightPhase  + 1 ) : ( LengthofFlightPhase + LengthofContactPhase_EMGSamplingHz( o ) ), o );



%Find the data points in ViggianiBarrett_DFPFCommonality, Activity, and Coactivation that correspond
%to flight phase only
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    ViggianiBarrett_DFPFCommonality_FlightPhase( 1 : LengthofFlightPhase , o ) = ViggianiBarrett_DFPFCommonality(  1 : LengthofFlightPhase , o );
    
                                    ViggianiBarrett_DFPFActivity_FlightPhase( 1 : LengthofFlightPhase , o ) = ViggianiBarrett_DFPFActivity(  1 : LengthofFlightPhase , o );
    
                                    ViggianiBarrett_DFPFCoactivation_FlightPhase( 1 : LengthofFlightPhase , o ) = ViggianiBarrett_DFPFCoactivation(  1 : LengthofFlightPhase , o );
                                 end


%Find the data points in ViggianiBarrett_DFPFCommonality, Activity, and Coactivation that correspond
%to contact phase only. Since contact phase begins one frame after end of flight phase, can simply
%add 1 to LengthofFlightPhase
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    ViggianiBarrett_DFPFCommonality_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o ), o ) = ViggianiBarrett_DFPFCommonality( ( LengthofFlightPhase  + 1 ) : ( LengthofFlightPhase + LengthofContactPhase_EMGSamplingHz( o ) ), o );
    
                                    ViggianiBarrett_DFPFActivity_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o ), o ) = ViggianiBarrett_DFPFActivity(  ( LengthofFlightPhase  + 1 ) : ( LengthofFlightPhase + LengthofContactPhase_EMGSamplingHz( o ) ), o );
    
                                    ViggianiBarrett_DFPFCoactivation_ContactPhase( 1 : LengthofContactPhase_EMGSamplingHz( o ), o ) = ViggianiBarrett_DFPFCoactivation(  ( LengthofFlightPhase  + 1 ) : ( LengthofFlightPhase + LengthofContactPhase_EMGSamplingHz( o ) ), o );
                                 end

 %NOTE - do NOT need to repeat the above four blocks of code for absorption and generation phase - have already calculated Viggiani-Barrett coactivation for absorption and generation phases                               
                                
 
                                
%% Coactivation Ratios for Entire Hop Cycle                       

    
                                %Add all TS integrated EMG together - for the entire hop cycle
                                AllTSActivity_EntireHopCycle( o, n ) =  sum( [ GasMed_CumSumIntegratedEMG( o ), GasLat_CumSumIntegratedEMG( o ), Sol_CumSumIntegratedEMG( o ) ] );
                                
                                
                                %Add all PF integrated EMG together - for entire hop cycle
                                AllPFActivity_EntireHopCycle( o, n ) = sum( [ GasMed_CumSumIntegratedEMG( o ), GasLat_CumSumIntegratedEMG( o ),...
                                    Sol_CumSumIntegratedEMG( o ), PL_CumSumIntegratedEMG( o ) ] );


                                %Add MedGas and Soleus integrated EMG together - for entire hop
                                %cycle
                                MedGasandSolActivity_EntireHopCycle( o, n ) = sum( [ GasMed_CumSumIntegratedEMG( o ), Sol_CumSumIntegratedEMG( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for entire hop
                                %cycle
                                MedGasandSolandPLActivity_EntireHopCycle( o, n ) = sum( [ GasMed_CumSumIntegratedEMG( o ), Sol_CumSumIntegratedEMG( o ), PL_CumSumIntegratedEMG( o ) ] );



                                %Add MedGas and LatGas integrated EMG together
                                GastrocnemiiActivity_EntireHopCycle( o, n ) = sum( [ GasMed_CumSumIntegratedEMG( o ), GasLat_CumSumIntegratedEMG( o ) ] );
                                
                                



                                %Calculate contribution of TS to total PF integrated EMG - entire
                                %hop cycle
                                TSContributiontoPFActivity_EntireHopCycle( o, n ) = AllTSActivity_EntireHopCycle( o, n ) ./ AllPFActivity_EntireHopCycle( o, n );

                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - entire hop cycle
                                MedGasandSolContributiontoPFActivity_EntireHopCycle( o, n ) = MedGasandSolActivity_EntireHopCycle( o, n ) ./ MedGasandSolandPLActivity_EntireHopCycle( o, n );
                                
                                
                                

                                 %Calculate contribution of gastrocnemii to total PF integrated EMG -
                                %contact phase
                                GastrocnemiiContributiontoPFActivity_EntireHopCycle( o, n ) = GastrocnemiiActivity_EntireHopCycle( o, n ) ./ AllPFActivity_EntireHopCycle( o, n );
                                
                                
                                %Calculate contribution of soleus to total PFintegrated EMG -
                                %contact phase
                                SolContributiontoPFActivity_EntireHopCycle( o, n ) = Sol_CumSumIntegratedEMG( o ) ./ AllPFActivity_EntireHopCycle( o, n );
                                
                                
                                %Calculate contribution of soleus to total TS integrated EMG -
                                %contact phase
                                SolContributiontoTSActivity_EntireHopCycle( o, n ) = Sol_CumSumIntegratedEMG( o ) ./ AllTSActivity_EntireHopCycle( o, n );
                                
                                
                                
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Calculate ratio of TA to all PF integrated EMG - entire hop cycle -
                                    %include LatGas
                                    TAvsAllPF_CoactivationRatio_EntireHopCycle( o, n ) = TA_CumSumIntegratedEMG( o, n ) ./ AllPFActivity_EntireHopCycle( o, n );
    
                                                                    
                                    %Calculate ratio of TA to all PF integrated EMG - entire hop cycle -
                                    %EXCLUDE LatGas
                                    TAvsAllbutLGas_CoactivationRatio_EntireHopCycle( o, n ) = TA_CumSumIntegratedEMG( o, n ) ./ MedGasandSolandPLActivity_EntireHopCycle( o, n );
                                 end
                                
                                
                                
                                
                                
    %% Add Data to Tble to be Exported to R                            

    
                                                                    
                                %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 7 ) = GasMed_CumSumIntegratedEMG( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 8 ) = GasLat_CumSumIntegratedEMG( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 9 ) = Sol_CumSumIntegratedEMG( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 10 ) = PL_CumSumIntegratedEMG( o );
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 11 ) = TA_CumSumIntegratedEMG( o, n );
                                     else
                                         AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 11 ) = NaN;
                                     end
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 12 ) = GasMed_CumSumIntegratedEMG_ContactPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 13 ) = GasLat_CumSumIntegratedEMG_ContactPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 14 ) = Sol_CumSumIntegratedEMG_ContactPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 15 ) = PL_CumSumIntegratedEMG_ContactPhase( o );
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 16 ) = TA_CumSumIntegratedEMG_ContactPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 16 ) = NaN;
                                     end
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 17 ) = GasMed_CumSumIntegratedEMG_BrakingPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 18 ) = GasLat_CumSumIntegratedEMG_BrakingPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 19 ) = Sol_CumSumIntegratedEMG_BrakingPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 20 ) = PL_CumSumIntegratedEMG_BrakingPhase( o );
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 21 ) = TA_CumSumIntegratedEMG_BrakingPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 21 ) = NaN;
                                     end
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 22 ) = GasMed_CumSumIntegratedEMG_PropulsionPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 23 ) = GasLat_CumSumIntegratedEMG_PropulsionPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 24 ) = Sol_CumSumIntegratedEMG_PropulsionPhase( o );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 25 ) = PL_CumSumIntegratedEMG_PropulsionPhase( o );
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 26 ) = TA_CumSumIntegratedEMG_PropulsionPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 26 ) = NaN;
                                     end
                                    
                                    
                               
    
        
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 27 ) = TSContributiontoPFActivity_EntireHopCycle( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 28 ) = MedGasandSolContributiontoPFActivity_EntireHopCycle( o, n );
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 29 ) = GastrocnemiiContributiontoPFActivity_EntireHopCycle( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 30 ) = SolContributiontoPFActivity_EntireHopCycle( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 31 ) = SolContributiontoTSActivity_EntireHopCycle( o, n );
                                    
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 32 ) = TAvsAllPF_CoactivationRatio_EntireHopCycle( o, n );
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 33 ) = TAvsAllbutLGas_CoactivationRatio_EntireHopCycle( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 32 ) = NaN;
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 33 ) = NaN;
                                     end

                                end%END IF STATEMENT FOR ADDING NEW DATA TO Tble FOR EXPORT
                                 

                                
                                
                                
                                
                                
   

         %% Coactivation Ratios for Flight Phase                    

                                %Add all TS integrated EMG together - for flight phase
                                AllTSActivity_FlightPhase( o, n ) =  sum( [ GasMed_CumSumIntegratedEMG_FlightPhase( o ), GasLat_CumSumIntegratedEMG_FlightPhase( o ), Sol_CumSumIntegratedEMG_FlightPhase( o ) ] );

                                %Add all PF integrated EMG together - for contact phase
                                AllPFActivity_FlightPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_FlightPhase( o ), GasLat_CumSumIntegratedEMG_FlightPhase( o ),...
                                    Sol_CumSumIntegratedEMG_FlightPhase( o ), PL_CumSumIntegratedEMG_FlightPhase( o ) ] );



                                %Add MedGas and Soleus integrated EMG together - for flight phase
                                MedGasandSolActivity_FlightPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_FlightPhase( o ), Sol_CumSumIntegratedEMG_FlightPhase( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for flight phase
                                MedGasandSolandPLActivity_FlightPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_FlightPhase( o ), Sol_CumSumIntegratedEMG_FlightPhase( o ), PL_CumSumIntegratedEMG_FlightPhase( o ) ] );


                                
                                
                                
                                %Calculate contribution of TS to total PF integrated EMG - flight
                                %phase
                                TSContributiontoPFActivity_FlightPhase( o, n ) = AllTSActivity_FlightPhase( o, n ) ./ AllPFActivity_FlightPhase( o, n );

                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - flight phase
                                MedGasandSolContributiontoPFActivity_FlightPhase( o, n ) = MedGasandSolActivity_FlightPhase( o, n ) ./ MedGasandSolandPLActivity_FlightPhase( o, n );

                                
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Calculate ratio of TA to all PF integrated EMG - flight phase -
                                    %include LatGas
                                    TAvsAllPF_CoactivationRatio_FlightPhase( o, n ) = TA_CumSumIntegratedEMG_FlightPhase( o, n ) ./ AllPFActivity_FlightPhase( o, n );
                                    
                                    %Calculate ratio of TA to all PF integrated EMG - flight phase -
                                    %EXCLUDE LatGas
                                    TAvsAllbutLGas_CoactivationRatio_FlightPhase( o, n ) = TA_CumSumIntegratedEMG_FlightPhase( o, n ) ./ MedGasandSolandPLActivity_FlightPhase( o, n );
                                 end

                                
    %% Add Data to Tble to be Exported to R

    

                                %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 34 ) = TSContributiontoPFActivity_FlightPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 35 ) = MedGasandSolContributiontoPFActivity_FlightPhase( o, n );
    
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 36 ) = TAvsAllPF_CoactivationRatio_FlightPhase( o, n );
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 37 ) = TAvsAllbutLGas_CoactivationRatio_FlightPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 36 ) = NaN;
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 37 ) = NaN;
                                     end
                                    
                                end%END IF STATEMENT FOR ADDING NEW DATA TO Tble FOR EXPORT
                                
     
                       
   
                                
                                
     %% Coactivation Ratios for Contact Phase                   

                                %Add all TS integrated EMG together - for contact phase
                                AllTSActivity_ContactPhase( o, n ) =  sum( [ GasMed_CumSumIntegratedEMG_ContactPhase( o ), GasLat_CumSumIntegratedEMG_ContactPhase( o ), Sol_CumSumIntegratedEMG_ContactPhase( o ) ] );

                                %Add all PF integrated EMG together - for contact phase
                                AllPFActivity_ContactPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_ContactPhase( o ), GasLat_CumSumIntegratedEMG_ContactPhase( o ),...
                                    Sol_CumSumIntegratedEMG_ContactPhase( o ), PL_CumSumIntegratedEMG_ContactPhase( o ) ] );


                                %Add MedGas and Soleus integrated EMG together - for contact phase
                                MedGasandSolActivity_ContactPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_ContactPhase( o ), Sol_CumSumIntegratedEMG_ContactPhase( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for contact phase
                                MedGasandSolandPLActivity_ContactPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_ContactPhase( o ), Sol_CumSumIntegratedEMG_ContactPhase( o ), PL_CumSumIntegratedEMG_ContactPhase( o ) ] );


                                %Add MedGas and LatGas integrated EMG together
                                GastrocnemiiActivity_ContactPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_ContactPhase( o ), GasLat_CumSumIntegratedEMG_ContactPhase( o ) ] );
                                
                                
                                
                                %Calculate contributio of MedGas to All TS - contact phase
                                MedGasContributiontoTS_ContactPhase(o, n) = GasMed_CumSumIntegratedEMG_ContactPhase( o ) ./ AllTSActivity_ContactPhase( o, n );
                                
                                %Calculate contributio of Gastrocnemii to All TS - contact phase
                                GastrocnemiiContributiontoTS_ContactPhase(o, n) = GastrocnemiiActivity_ContactPhase( o, n ) ./ AllTSActivity_ContactPhase( o, n );


                                %Calculate contribution of TS to total PF integrated EMG - contact
                                %phase
                                TSContributiontoPFActivity_ContactPhase( o, n ) = AllTSActivity_ContactPhase( o, n ) ./ AllPFActivity_ContactPhase( o, n );

                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - contact phase
                                MedGasandSolContributiontoPFActivity_ContactPhase( o, n ) = MedGasandSolActivity_ContactPhase( o, n ) ./ MedGasandSolandPLActivity_ContactPhase( o, n );

                                
                                
                                
                                %Calculate contribution of gastrocnemii to total PF integrated EMG -
                                %contact phase
                                GastrocnemiiContributiontoPFActivity_ContactPhase( o, n ) = GastrocnemiiActivity_ContactPhase( o, n ) ./ AllPFActivity_ContactPhase( o, n );
                                
                                
                                %Calculate contribution of soleus to total PFintegrated EMG -
                                %contact phase
                                SolContributiontoPFActivity_ContactPhase( o, n ) = Sol_CumSumIntegratedEMG_ContactPhase( o ) ./ AllPFActivity_ContactPhase( o, n );
                                
                                
                                %Calculate contribution of soleus to total TS integrated EMG -
                                %contact phase
                                SolContributiontoTSActivity_ContactPhase( o, n ) = Sol_CumSumIntegratedEMG_ContactPhase( o ) ./ AllTSActivity_ContactPhase( o, n );
                                
                                
                                
                                
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Calculate ratio of TA to all PF integrated EMG - contact phase -
                                    %include LatGas
                                    TAvsAllPF_CoactivationRatio_ContactPhase( o, n ) = TA_CumSumIntegratedEMG_ContactPhase( o, n ) ./ AllPFActivity_ContactPhase( o, n );
                                    
                                    %Calculate ratio of TA to all PF integrated EMG - contact phase -
                                    %EXCLUDE LatGas
                                    TAvsAllbutLGas_CoactivationRatio_ContactPhase( o, n ) = TA_CumSumIntegratedEMG_ContactPhase( o, n ) ./ MedGasandSolandPLActivity_ContactPhase( o, n );
                                 end

                                %Calculate ratio of total PF integrated EMG for the contact phase
                                %versus that for the MSLVJ task for the reference contraction
                                % PFCoactivationRatio_HopvsMSLVJ( o, n ) = AllPFActivity_ContactPhase( o, n ) ./ SummedIntegratedEMG_SLVJ;
                                
                                
    %% Add Data to Tble to be Exported to R

   
                                  
                                        
                                %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 38 ) = TSContributiontoPFActivity_ContactPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 39 ) = MedGasandSolContributiontoPFActivity_ContactPhase( o, n );
    
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 40 ) = GastrocnemiiContributiontoPFActivity_ContactPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 41 ) = SolContributiontoPFActivity_ContactPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 42 ) = MedGasContributiontoTS_ContactPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 43 ) = GastrocnemiiContributiontoTS_ContactPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 44 ) = SolContributiontoTSActivity_ContactPhase( o, n );
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 45 ) = TAvsAllPF_CoactivationRatio_ContactPhase( o, n );
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 46 ) = TAvsAllbutLGas_CoactivationRatio_ContactPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 45 ) = NaN;
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 46 ) = NaN;
                                     end
                                    % AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 47) = PFCoactivationRatio_HopvsMSLVJ( o, n ) ;

                                end%END IF STATEMENT FOR ADDING DATA TO Tble FOR EXPORT
                                
                                
                                
     %% Coactivation Ratios for Absorption Phase                   

                                %Sum the activity from GasMed, GasLat, and Sol for absorption phase
                                AllTSActivity_BrakingPhase( o, n ) =  sum( [ GasMed_CumSumIntegratedEMG_BrakingPhase( o ), GasLat_CumSumIntegratedEMG_BrakingPhase( o ), Sol_CumSumIntegratedEMG_BrakingPhase( o ) ] );

                                %Sum the activity of all PF (Gas Heads, Sol, PL) for absorption
                                %phase
                                AllPFActivity_BrakingPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_BrakingPhase( o ), GasLat_CumSumIntegratedEMG_BrakingPhase( o ),...
                                    Sol_CumSumIntegratedEMG_BrakingPhase( o ), PL_CumSumIntegratedEMG_BrakingPhase( o ) ] );
                                
                                %Sum the activity of the Gas Heads for absorption phase
                                TwoJointTSActivity_BrakingPhase(o, n) = sum( [ GasMed_CumSumIntegratedEMG_BrakingPhase( o ), GasLat_CumSumIntegratedEMG_BrakingPhase( o ) ] );
                                
                                
                                %Add MedGas and Soleus integrated EMG together - for braking phase
                                MedGasandSolActivity_BrakingPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_BrakingPhase( o ), Sol_CumSumIntegratedEMG_BrakingPhase( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for braking phase
                                MedGasandSolandPLActivity_BrakingPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_BrakingPhase( o ), Sol_CumSumIntegratedEMG_BrakingPhase( o ), PL_CumSumIntegratedEMG_BrakingPhase( o ) ] );
                                
                                

                                
                                
                                %Ratio of TS Activity to All PF Activity
                                TSContributiontoPFActivity_BrakingPhase( o, n ) = AllTSActivity_BrakingPhase( o, n ) ./ AllPFActivity_BrakingPhase( o, n );
                                
                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - contact phase
                                MedGasandSolContributiontoPFActivity_BrakingPhase( o, n ) = MedGasandSolActivity_BrakingPhase( o, n ) ./ MedGasandSolandPLActivity_BrakingPhase( o, n );
                                
                                
                                %Ratio of Two-Joint (Gastroc Heads) and One-Joint (Sol) Activity to
                                %All PF Activity
                                TwoJointTS_Contribution2AllPF_BrakingPhase( o, n ) = TwoJointTSActivity_BrakingPhase(o, n) ./ AllPFActivity_BrakingPhase( o, n );
                                OneJointTS_Contribution2AllPF_BrakingPhase( o, n ) = Sol_CumSumIntegratedEMG_BrakingPhase( o ) ./ AllPFActivity_BrakingPhase( o, n );
                                
                                
                                %Ratio of GasMed activity to all TS activity - absorption phase
                                MedGasContributiontoAllTS_BrakingPhase( o, n ) = GasMed_CumSumIntegratedEMG_BrakingPhase( o ) ./ AllTSActivity_BrakingPhase( o, n ) ;
                                
                                
                                %Ratio of Sol activity to all TS activity - absorption phase
                                SolContributiontoAllTS_BrakingPhase( o, n ) = Sol_CumSumIntegratedEMG_BrakingPhase( o ) ./ AllTSActivity_BrakingPhase( o, n ) ;
                                
                                %Two-joint TS contribution to TS activation - absorption phase
                                TwoJointTS_Contribution2TS_BrakingPhase( o, n ) = TwoJointTSActivity_BrakingPhase(o, n) ./ AllTSActivity_BrakingPhase( o, n ) ;
                                

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Ratio of TA activity to all PF activity - absorption phase
                                    TAvsAllPF_CoactivationRatio_BrakingPhase( o, n ) = TA_CumSumIntegratedEMG_BrakingPhase( o, n ) ./ AllPFActivity_BrakingPhase( o, n );
                                 end
                                 
                                %Calculate ratio of total PF integrated EMG for the braking phase
                                %versus that for the MSLVJ task for the reference contraction
                                % PFCoactivationRatio_HopvsMSLVJ_BrakingPhase( o, n ) = AllPFActivity_BrakingPhase( o, n ) ./ SummedIntegratedEMG_SLVJ_BrakingPhase;


    %% Add Data to Tble to be Exported to R

    
    
                                        
                                %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 48 ) = TSContributiontoPFActivity_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 49 ) = MedGasandSolContributiontoPFActivity_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 50 ) = MedGasContributiontoAllTS_BrakingPhase( o, n );
                                    
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 51 ) = TAvsAllPF_CoactivationRatio_BrakingPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 51 ) = NaN;
                                     end
                                    
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 52 ) = TwoJointTS_Contribution2AllPF_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 53 ) = OneJointTS_Contribution2AllPF_BrakingPhase( o, n );
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 54 ) = SolContributiontoAllTS_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 55 ) = TwoJointTS_Contribution2TS_BrakingPhase( o, n );
                                    % AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 56) = PFCoactivationRatio_HopvsMSLVJ_BrakingPhase( o, n ) ;
                                
                                end%END IF STATMENT FOR ADDING DATA TO Tble FOR EXPORT
                                

                                
                                
                                
     %% Coactivation Ratios for Propulsion Phase                   

                                %Sum the activity from GasMed, GasLat, and Sol for generation phase
                                AllTSActivity_PropulsionPhase( o, n ) =  sum( [ GasMed_CumSumIntegratedEMG_PropulsionPhase( o ), GasLat_CumSumIntegratedEMG_PropulsionPhase( o ), Sol_CumSumIntegratedEMG_PropulsionPhase( o ) ] );

                                %Sum the activity of all PF (Gas Heads, Sol, PL) for generation
                                %phase
                                AllPFActivity_PropulsionPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_PropulsionPhase( o ), GasLat_CumSumIntegratedEMG_PropulsionPhase( o ),...
                                    Sol_CumSumIntegratedEMG_PropulsionPhase( o ), PL_CumSumIntegratedEMG_PropulsionPhase( o ) ] );
                                
                                %Sum the activity of the Gas Heads for generation phase
                                TwoJointTSActivity_PropulsionPhase(o, n) = sum( [ GasMed_CumSumIntegratedEMG_PropulsionPhase( o ), GasLat_CumSumIntegratedEMG_PropulsionPhase( o ) ] );
                                

                                %Add MedGas and Soleus integrated EMG together - for braking phase
                                MedGasandSolActivity_PropulsionPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_PropulsionPhase( o ), Sol_CumSumIntegratedEMG_PropulsionPhase( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for braking phase
                                MedGasandSolandPLActivity_PropulsionPhase( o, n ) = sum( [ GasMed_CumSumIntegratedEMG_PropulsionPhase( o ), Sol_CumSumIntegratedEMG_PropulsionPhase( o ), PL_CumSumIntegratedEMG_PropulsionPhase( o ) ] );
                                
                                
                                

                                
                                %Ratio of TS Activity to All PF Activity
                                TSContributiontoPFActivity_PropulsionPhase( o, n ) = AllTSActivity_PropulsionPhase( o, n ) ./ AllPFActivity_PropulsionPhase( o, n );
                                
                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - contact phase
                                MedGasandSolContributiontoPFActivity_PropulsionPhase( o, n ) = MedGasandSolActivity_PropulsionPhase( o, n ) ./ MedGasandSolandPLActivity_PropulsionPhase( o, n );
                                
                                
                                %Ratio of Two-Joint (Gastroc Heads) and One-Joint (Sol) Activity to
                                %All PF Activity
                                TwoJointTS_Contribution2AllPF_PropulsionPhase( o, n ) = TwoJointTSActivity_PropulsionPhase(o, n) ./ AllPFActivity_PropulsionPhase( o, n );
                                OneJointTS_Contribution2AllPF_PropulsionPhase( o, n ) = Sol_CumSumIntegratedEMG_PropulsionPhase( o ) ./ AllPFActivity_PropulsionPhase( o, n );
                                
                                %Ratio of GasMed activity to all TS activity
                                MedGasContributiontoAllTS_PropulsionPhase( o, n ) = GasMed_CumSumIntegratedEMG_PropulsionPhase( o ) ./ AllTSActivity_PropulsionPhase( o, n ) ;

                                %Ratio of Sol activity to all TS activity
                                SolContributiontoAllTS_PropulsionPhase( o, n ) = Sol_CumSumIntegratedEMG_PropulsionPhase( o ) ./ AllTSActivity_PropulsionPhase( o, n ) ;
                                
                                %Two-joint TS contribution to TS activation - propulsion phase
                                TwoJointTS_Contribution2TS_PropulsionPhase( o, n ) = TwoJointTSActivity_PropulsionPhase(o, n) ./ AllTSActivity_PropulsionPhase( o, n ) ;
                                
                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                %Ratio of TA activity to all PF activity
                                TAvsAllPF_CoactivationRatio_PropulsionPhase( o, n ) = TA_CumSumIntegratedEMG_PropulsionPhase( o, n ) ./ AllPFActivity_PropulsionPhase( o, n );
                                 end


                                %Calculate ratio of total PF integrated EMG for the propulsion phase
                                %versus that for the MSLVJ task for the reference contraction
                               % PFCoactivationRatio_HopvsMSLVJ_PropulsionPhase( o, n ) = AllPFActivity_PropulsionPhase( o, n ) ./ SummedIntegratedEMG_SLVJ_PropulsionPhase;



    %% Add Data to Tble to be Exported to R


                               %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 57 ) = TSContributiontoPFActivity_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 58 ) = MedGasandSolContributiontoPFActivity_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 59 ) = MedGasContributiontoAllTS_PropulsionPhase( o, n );
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 60 ) = TAvsAllPF_CoactivationRatio_PropulsionPhase( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 60 ) = NaN;
                                     end
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 61 ) = TwoJointTS_Contribution2AllPF_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 62 ) = OneJointTS_Contribution2AllPF_PropulsionPhase( o, n );
                                    
    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 63 ) = SolContributiontoAllTS_PropulsionPhase( o, n );
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 64 ) = TwoJointTS_Contribution2TS_PropulsionPhase( o, n );
                                    % AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 65) = PFCoactivationRatio_HopvsMSLVJ_PropulsionPhase( o, n ) ;

                                end%END IF STATEMENT FOR ADDING DATA TO Tble FOR EXPORT



%% Coactivation Ratios for Braking Phase - Average

                                %Sum the activity from GasMed, GasLat, and Sol for absorption phase
                                AllTSActivity_BrakingPhase_Average( o, n ) =  sum( [ GasMed_AverageIntegratedEMG_BrakingPhase( o ), GasLat_AverageIntegratedEMG_BrakingPhase( o ), Sol_AverageIntegratedEMG_BrakingPhase( o ) ] );

                                %Sum the activity of all PF (Gas Heads, Sol, PL) for absorption
                                %phase
                                AllPFActivity_BrakingPhase_Average( o, n ) = sum( [ GasMed_AverageIntegratedEMG_BrakingPhase( o ), GasLat_AverageIntegratedEMG_BrakingPhase( o ),...
                                    Sol_AverageIntegratedEMG_BrakingPhase( o ), PL_AverageIntegratedEMG_BrakingPhase( o ) ] );
                                
                                %Sum the activity of the Gas Heads for absorption phase
                                TwoJointTSActivity_BrakingPhase_Average(o, n) = sum( [ GasMed_AverageIntegratedEMG_BrakingPhase( o ), GasLat_AverageIntegratedEMG_BrakingPhase( o ) ] );
                                
                                
                                %Add MedGas and Soleus integrated EMG together - for braking phase
                                MedGasandSolActivity_BrakingPhase_Average( o, n ) = sum( [ GasMed_AverageIntegratedEMG_BrakingPhase( o ), Sol_AverageIntegratedEMG_BrakingPhase( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for braking phase
                                MedGasandSolandPLActivity_BrakingPhase_Average( o, n ) = sum( [ GasMed_AverageIntegratedEMG_BrakingPhase( o ), Sol_AverageIntegratedEMG_BrakingPhase( o ), PL_AverageIntegratedEMG_BrakingPhase( o ) ] );
                                

                                
                                
                                %Ratio of TS Activity to All PF Activity
                                TSContributiontoPFActivity_BrakingPhase_Average( o, n ) = AllTSActivity_BrakingPhase_Average( o, n ) ./ AllPFActivity_BrakingPhase_Average( o, n );
                                
                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - contact phase
                                MedGasandSolContributiontoPFActivity_BrakingPhase_Average( o, n ) = MedGasandSolActivity_BrakingPhase_Average( o, n ) ./ MedGasandSolandPLActivity_BrakingPhase_Average( o, n );
                                
                                
                                %Ratio of Two-Joint (Gastroc Heads) and One-Joint (Sol) Activity to
                                %All PF Activity
                                TwoJointTS_Contribution2AllPF_BrakingPhase_Average( o, n ) = TwoJointTSActivity_BrakingPhase_Average(o, n) ./ AllPFActivity_BrakingPhase_Average( o, n );
                                OneJointTS_Contribution2AllPF_BrakingPhase_Average( o, n ) = Sol_AverageIntegratedEMG_BrakingPhase( o ) ./ AllPFActivity_BrakingPhase_Average( o, n );
                                
                                
                                %Ratio of GasMed activity to all TS activity - absorption phase
                                MedGasContributiontoAllTS_BrakingPhase_Average( o, n ) = GasMed_AverageIntegratedEMG_BrakingPhase( o ) ./ AllTSActivity_BrakingPhase_Average( o, n ) ;
                                
                                
                                %Ratio of Sol activity to all TS activity - absorption phase
                                SolContributiontoAllTS_BrakingPhase_Average( o, n ) = Sol_AverageIntegratedEMG_BrakingPhase( o ) ./ AllTSActivity_BrakingPhase_Average( o, n ) ;
                                
                                %Two-joint TS contribution to TS activation - absorption phase
                                TwoJointTS_Contribution2TS_BrakingPhase_Average( o, n ) = TwoJointTSActivity_BrakingPhase_Average(o, n) ./ AllTSActivity_BrakingPhase_Average( o, n ) ;
                                

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Ratio of TA activity to all PF activity - absorption phase
                                    TAvsAllPF_CoactivationRatio_BrakingPhase_Average( o, n ) = TA_AverageIntegratedEMG_BrakingPhase( o, n ) ./ AllPFActivity_BrakingPhase_Average( o, n );
                                 end
                                 

                                


%% Add Data to Tble to be Exported to R - Average Braking Phase

    
    
                                        
                                %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 66 ) = GasMed_AverageIntegratedEMG_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 67 ) = GasLat_AverageIntegratedEMG_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 68 ) = Sol_AverageIntegratedEMG_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 69 ) = PL_AverageIntegratedEMG_BrakingPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 70 ) = TA_AverageIntegratedEMG_BrakingPhase( o, n );
    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 71 ) = TSContributiontoPFActivity_BrakingPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 72 ) = MedGasandSolContributiontoPFActivity_BrakingPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 73 ) = MedGasContributiontoAllTS_BrakingPhase_Average( o, n );
                                    
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 74 ) = TAvsAllPF_CoactivationRatio_BrakingPhase_Average( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 74 ) = NaN;
                                     end
                                    
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 75 ) = TwoJointTS_Contribution2AllPF_BrakingPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 76 ) = OneJointTS_Contribution2AllPF_BrakingPhase_Average( o, n );
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 77 ) = SolContributiontoAllTS_BrakingPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 78 ) = TwoJointTS_Contribution2TS_BrakingPhase_Average( o, n );

                                end%END IF STATEMENT FOR ADDING NEW DATA TO Tble FOR EXPORT



%% Coactivation Ratios for Propulsion Phase - Average

                                %Sum the activity from GasMed, GasLat, and Sol for absorption phase
                                AllTSActivity_PropulsionPhase_Average( o, n ) =  sum( [ GasMed_AverageIntegratedEMG_PropulsionPhase( o ), GasLat_AverageIntegratedEMG_PropulsionPhase( o ), Sol_AverageIntegratedEMG_PropulsionPhase( o ) ] );

                                %Sum the activity of all PF (Gas Heads, Sol, PL) for absorption
                                %phase
                                AllPFActivity_PropulsionPhase_Average( o, n ) = sum( [ GasMed_AverageIntegratedEMG_PropulsionPhase( o ), GasLat_AverageIntegratedEMG_PropulsionPhase( o ),...
                                    Sol_AverageIntegratedEMG_PropulsionPhase( o ), PL_AverageIntegratedEMG_PropulsionPhase( o ) ] );
                                
                                %Sum the activity of the Gas Heads for absorption phase
                                TwoJointTSActivity_PropulsionPhase_Average(o, n) = sum( [ GasMed_AverageIntegratedEMG_PropulsionPhase( o ), GasLat_AverageIntegratedEMG_PropulsionPhase( o ) ] );
                                
                                
                                %Add MedGas and Soleus integrated EMG together - for Propulsion phase
                                MedGasandSolActivity_PropulsionPhase_Average( o, n ) = sum( [ GasMed_AverageIntegratedEMG_PropulsionPhase( o ), Sol_AverageIntegratedEMG_PropulsionPhase( o ) ] );

                                %Add MedGas, Sol, and PL integrated EMG together - for Propulsion phase
                                MedGasandSolandPLActivity_PropulsionPhase_Average( o, n ) = sum( [ GasMed_AverageIntegratedEMG_PropulsionPhase( o ), Sol_AverageIntegratedEMG_PropulsionPhase( o ), PL_AverageIntegratedEMG_PropulsionPhase( o ) ] );
                                
                                

                                
                                
                                %Ratio of TS Activity to All PF Activity
                                TSContributiontoPFActivity_PropulsionPhase_Average( o, n ) = AllTSActivity_PropulsionPhase_Average( o, n ) ./ AllPFActivity_PropulsionPhase_Average( o, n );
                                
                                %Calculate contribution of only MedGas and Sol to total PF
                                %integrated EMG ( MedGas, Sol, PL ) - contact phase
                                MedGasandSolContributiontoPFActivity_PropulsionPhase_Average( o, n ) = MedGasandSolActivity_PropulsionPhase_Average( o, n ) ./ MedGasandSolandPLActivity_PropulsionPhase_Average( o, n );
                                
                                
                                %Ratio of Two-Joint (Gastroc Heads) and One-Joint (Sol) Activity to
                                %All PF Activity
                                TwoJointTS_Contribution2AllPF_PropulsionPhase_Average( o, n ) = TwoJointTSActivity_PropulsionPhase_Average(o, n) ./ AllPFActivity_PropulsionPhase_Average( o, n );
                                OneJointTS_Contribution2AllPF_PropulsionPhase_Average( o, n ) = Sol_AverageIntegratedEMG_PropulsionPhase( o ) ./ AllPFActivity_PropulsionPhase_Average( o, n );
                                
                                
                                %Ratio of GasMed activity to all TS activity - absorption phase
                                MedGasContributiontoAllTS_PropulsionPhase_Average( o, n ) = GasMed_AverageIntegratedEMG_PropulsionPhase( o ) ./ AllTSActivity_PropulsionPhase_Average( o, n ) ;
                                
                                
                                %Ratio of Sol activity to all TS activity - absorption phase
                                SolContributiontoAllTS_PropulsionPhase_Average( o, n ) = Sol_AverageIntegratedEMG_PropulsionPhase( o ) ./ AllTSActivity_PropulsionPhase_Average( o, n ) ;
                                
                                %Two-joint TS contribution to TS activation - absorption phase
                                TwoJointTS_Contribution2TS_PropulsionPhase_Average( o, n ) = TwoJointTSActivity_PropulsionPhase_Average(o, n) ./ AllTSActivity_PropulsionPhase_Average( o, n ) ;
                                

                                 if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                    %Ratio of TA activity to all PF activity - absorption phase
                                    TAvsAllPF_CoactivationRatio_PropulsionPhase_Average( o, n ) = TA_AverageIntegratedEMG_PropulsionPhase( o, n ) ./ AllPFActivity_PropulsionPhase_Average( o, n );
                                 end
                                 

                                


%% Add Data to Tble to be Exported to R - Average Propulsion Phase

    
    
                                        
                                %If we have NOT added Participant N data, add it to Tble for
                                %exporting
                                if strcmp( cell2mat( AddedParticipantNData_Cell ), 'No' ) || strcmp( cell2mat( AddedParticipantNData_Cell ), 'N' )

                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 79 ) = GasMed_AverageIntegratedEMG_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 80 ) = GasLat_AverageIntegratedEMG_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 81 ) = Sol_AverageIntegratedEMG_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 82 ) = PL_AverageIntegratedEMG_PropulsionPhase( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 83 ) = TA_AverageIntegratedEMG_PropulsionPhase( o, n );
    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 84 ) = TSContributiontoPFActivity_PropulsionPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 85 ) = MedGasandSolContributiontoPFActivity_PropulsionPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 86 ) = MedGasContributiontoAllTS_PropulsionPhase_Average( o, n );
                                    
    
                                     if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 87 ) = TAvsAllPF_CoactivationRatio_PropulsionPhase_Average( o, n );
                                     else
                                        AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 87 ) = NaN;
                                     end
                                    
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 88) = TwoJointTS_Contribution2AllPF_PropulsionPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 89 ) = OneJointTS_Contribution2AllPF_PropulsionPhase_Average( o, n );
                                    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 90 ) = SolContributiontoAllTS_PropulsionPhase_Average( o, n );
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 91 ) = TwoJointTS_Contribution2TS_PropulsionPhase_Average( o, n );
    



                                    %Save the Morphology for the current participant
                                    Morphology = round( MorphologyLog.DifferenceinTendonThickness_mm( strcmp(  ParticipantList{ l } , MorphologyLog.Participant_ID ) ), 2 );
                                    
                                    %If processing the ATx group, find the VAS for the current participant, current hop rate, current limb
                                    if strcmp( GroupList{m}, 'ATx' )
                                
                                        %Save the VAS for the current participant
                                        VAS = round( VASLog.VAS_Score( strcmp(  ParticipantList{ l } , VASLog.Participant ) & strcmp(  LimbID{a} , VASLog.Limb ) & ( VASLog.HoppingRate == HoppingRate_ID_forTable( b )  ) ), 2 );
                                    
                                     %VAS for control group is always 0
                                    else
                                    
                                        VAS = 0;
                                    
                                    end




                                    %Set the between-limb morphology
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 92) = Morphology;
                                     
                                     %Set theVAS rating
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 93)= VAS;

    
    
    
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 1) = k; %Store group ID in 1st column
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 2) = l;%Store participant ID in 2nd column
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 3) = a;%Store Limb ID in 3rd column
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 4) = n;%Store trial number in 4th column
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 5) = o;%Store hop number in 5th column
                                    AllTS_CoactivationRatio( RowtoFill_CoactivationRatio, 6) =HoppingRate_ID_forTble(b);%Store Hopping Rate ID in 6th column
    
                                    RowtoFill_CoactivationRatio = RowtoFill_CoactivationRatio + 1;                                      
                                
                                end%END IF STATMENT FOR ADDING NEW DATA TO Tble FOR EXPORT
                                
                                
%% Make Matrix Containing All Hops for Braking and Propulsion Phases


    %Braking phase data
    GasMed_BrakingPhase_AllHops( 1 : length( GasMed_OthHop_BrakingPhase ), o  ) = GasMed_OthHop_BrakingPhase;
    GasLat_BrakingPhase_AllHops( 1 : length( GasLat_OthHop_BrakingPhase ), o  ) = GasLat_OthHop_BrakingPhase;
    Sol_BrakingPhase_AllHops( 1 : length( Sol_OthHop_BrakingPhase ), o  ) = Sol_OthHop_BrakingPhase;
    PL_BrakingPhase_AllHops( 1 : length( PL_OthHop_BrakingPhase ), o  ) = PL_OthHop_BrakingPhase;
    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
    TA_BrakingPhase_AllHops( 1 : length( TA_OthHop_BrakingPhase ), o  ) = TA_OthHop_BrakingPhase;
    end


    %Propulsion phase data
    GasMed_PropulsionPhase_AllHops( 1 : length( GasMed_OthHop_PropulsionPhase ), o  ) = GasMed_OthHop_PropulsionPhase;
    GasLat_PropulsionPhase_AllHops( 1 : length( GasLat_OthHop_PropulsionPhase ), o  ) = GasLat_OthHop_PropulsionPhase;
    Sol_PropulsionPhase_AllHops( 1 : length( Sol_OthHop_PropulsionPhase ), o  ) = Sol_OthHop_PropulsionPhase;
    PL_PropulsionPhase_AllHops( 1 : length( PL_OthHop_PropulsionPhase ), o  ) = PL_OthHop_PropulsionPhase;
    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
    TA_PropulsionPhase_AllHops( 1 : length( TA_OthHop_PropulsionPhase ), o  ) = TA_OthHop_PropulsionPhase;
    end

                                
    %% End o for loop
                            end %End o for loop

                            NumberofRows_ViggianiBarrett_EntireHop = size( ViggianiBarrett_PFCommonality, 1);
                            NumberofRows_ViggianiBarrett_FlightPhase = size( ViggianiBarrett_PFCommonality, 1);
                            NumberofRows_ViggianiBarrett_ContactPhase = size( ViggianiBarrett_PFCommonality, 1);
                            NumberofRows_ViggianiBarrett_BrakingPhase = size( ViggianiBarrett_PFCommonality, 1);
                            NumberofRows_ViggianiBarrett_PropulsionPhase = size( ViggianiBarrett_PFCommonality, 1);
                            
                            
                            
%% Store Braking and Propulsion Phase EMG in Data Structure                            
                            
                            %Store the BRAKING phase of the high pass filtered EMG, for coherence,  in the data structure
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 1 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_BrakingPhase_forCoherence', GasMed_BrakingPhase_AllHops);

                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 2 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_BrakingPhase_forCoherence', GasLat_BrakingPhase_AllHops);
                            
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 3 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_BrakingPhase_forCoherence', Sol_BrakingPhase_AllHops);
                            
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 4 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_BrakingPhase_forCoherence', PL_BrakingPhase_AllHops);
                            
    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 5 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_BrakingPhase_forCoherence', TA_BrakingPhase_AllHops);
    end
                            
                            
                            
                            %Store the PROPULSION phase of the high pass filtered EMG, for coherence,  in the data structure
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 1 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_PropulsionPhase_forCoherence', GasMed_PropulsionPhase_AllHops);

                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 2 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_PropulsionPhase_forCoherence', GasLat_PropulsionPhase_AllHops);
                            
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 3 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_PropulsionPhase_forCoherence', Sol_PropulsionPhase_AllHops);
                            
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 4 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_PropulsionPhase_forCoherence', PL_PropulsionPhase_AllHops);
                            
    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                            David_DissertationEMGDataStructure =...
                                setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{ k }, ParticipantList{ l }, 'IndividualHops', LimbID{ a }, MuscleID{ 5 }, HoppingRate_ID{ b }, HoppingTrialNumber{ n }, 'RectifiedEMG_PropulsionPhase_forCoherence', TA_PropulsionPhase_AllHops);
    end
                            
                            
    %% Store Viggiani-Barrett Coactivation Measures for Individual Bouts of Hopping in Data Structure

    
% Viggiani-Barrett Coactiation - All PF ONLY      

                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCommonality_EntireHopCycle',ViggianiBarrett_PFCommonality);
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFActivity_EntireHopCycle',ViggianiBarrett_PFActivity);
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCoactivation_EntireHopCycle',ViggianiBarrett_PFCoactivation);  


                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCommonality_FlightPhase',ViggianiBarrett_PFCommonality_FlightPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFActivity_FlightPhase',ViggianiBarrett_PFActivity_FlightPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCoactivation_FlightPhase',ViggianiBarrett_PFCoactivation_FlightPhase);


                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCommonality_ContactPhase',ViggianiBarrett_PFCommonality_ContactPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFActivity_ContactPhase',ViggianiBarrett_PFActivity_ContactPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCoactivation_ContactPhase',ViggianiBarrett_PFCoactivation_ContactPhase);        


                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCommonality_BrakingPhase',ViggianiBarrett_PFCommonality_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFActivity_BrakingPhase',ViggianiBarrett_PFActivity_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCoactivation_BrakingPhase',ViggianiBarrett_PFCoactivation_BrakingPhase);        



                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCommonality_PropulsionPhase',ViggianiBarrett_PFCommonality_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFActivity_PropulsionPhase',ViggianiBarrett_PFActivity_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_PFCoactivation_PropulsionPhase',ViggianiBarrett_PFCoactivation_PropulsionPhase);      
                                    
                                    
                                    
                                    
                                    
 
                                    
% Viggiani-Barrett Coactiation - TS ONLY                                    
                                    
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_TSCommonality_BrakingPhase',ViggianiBarrett_TSCommonality_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_TSActivity_BrakingPhase',ViggianiBarrett_TSActivity_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_TSCoactivation_BrakingPhase',ViggianiBarrett_TSCoactivation_BrakingPhase);        



                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_TSCommonality_PropulsionPhase',ViggianiBarrett_TSCommonality_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_TSActivity_PropulsionPhase',ViggianiBarrett_TSActivity_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_TSCoactivation_PropulsionPhase',ViggianiBarrett_TSCoactivation_PropulsionPhase);                                         
                                    
 
                                    
                                    
% Viggiani-Barrett Coactiation - Two TS with PL                                  
                                    
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_2JntTSCommonality_BrakingPhase',ViggianiBarrett_2JntTSCommonality_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_2JntTSActivity_BrakingPhase',ViggianiBarrett_2JntTSActivity_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_2JntTSCoactivation_BrakingPhase',ViggianiBarrett_2JntTSCoactivation_BrakingPhase);        



                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_2JntTSCommonality_PropulsionPhase',ViggianiBarrett_2JntTSCommonality_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_2JntTSActivity_PropulsionPhase',ViggianiBarrett_2JntTSActivity_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_2JntTSCoactivation_PropulsionPhase',ViggianiBarrett_2JntTSCoactivation_PropulsionPhase);                                              
                                    
                                    
                                    
% Viggiani-Barrett Coactiation - One-Joint TS with PL                                    
                                    
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_1JntTSCommonality_BrakingPhase',ViggianiBarrett_1JntTSCommonality_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_1JntTSActivity_BrakingPhase',ViggianiBarrett_1JntTSActivity_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_1JntTSCoactivation_BrakingPhase',ViggianiBarrett_1JntTSCoactivation_BrakingPhase);        



                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_1JntTSCommonality_PropulsionPhase',ViggianiBarrett_1JntTSCommonality_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_1JntTSActivity_PropulsionPhase',ViggianiBarrett_1JntTSActivity_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_1JntTSCoactivation_PropulsionPhase',ViggianiBarrett_1JntTSCoactivation_PropulsionPhase);                                              
                                    
                                    
                                    
                                    

% Viggiani-Barrett Coactiation - DF vs PF ONLY      

    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                          David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCommonality_EntireHopCycle',ViggianiBarrett_DFPFCommonality);
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFActivity_EntireHopCycle',ViggianiBarrett_DFPFActivity);
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCoactivation_EntireHopCycle',ViggianiBarrett_DFPFCoactivation);  


                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCommonality_FlightPhase',ViggianiBarrett_DFPFCommonality_FlightPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFActivity_FlightPhase',ViggianiBarrett_DFPFActivity_FlightPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCoactivation_FlightPhase',ViggianiBarrett_DFPFCoactivation_FlightPhase);


                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCommonality_ContactPhase',ViggianiBarrett_DFPFCommonality_ContactPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFActivity_ContactPhase',ViggianiBarrett_DFPFActivity_ContactPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCoactivation_ContactPhase',ViggianiBarrett_DFPFCoactivation_ContactPhase);             
                                    
                                    
                                    
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCommonality_BrakingPhase',ViggianiBarrett_DFPFCommonality_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFActivity_BrakingPhase',ViggianiBarrett_DFPFActivity_BrakingPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCoactivation_BrakingPhase',ViggianiBarrett_DFPFCoactivation_BrakingPhase);                                           
                                    
                                    
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCommonality_PropulsionPhase',ViggianiBarrett_DFPFCommonality_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFActivity_PropulsionPhase',ViggianiBarrett_DFPFActivity_PropulsionPhase);
                           David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  HoppingTrialNumber{n},'ViggianiBarrett_DFPFCoactivation_PropulsionPhase',ViggianiBarrett_DFPFCoactivation_PropulsionPhase);               
                                    
    end
                                    
                                    
                                    
                                    
%% Add Indexing Data to Data Structure                                    
                                    
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'UseforIndexingIntoData',LimbID{a}, HoppingRate_ID{b},  HoppingTrialNumber{n},'LengthofBrakingPhase_EMGSampHz', LengthofBrakingPhase);  

                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'UseforIndexingIntoData',LimbID{a}, HoppingRate_ID{b},  HoppingTrialNumber{n},'LengthofPropulsionPhase_NonTruncated_EMGSampHz', LengthofPropulsionPhase_NonTruncated);  
                             

                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'UseforIndexingIntoData',LimbID{a}, HoppingRate_ID{b},  HoppingTrialNumber{n},'LengthofBrakingPhase_MoCapSampHz', MedGas_LengthofBrakingPhase_MoCapSampHz);  

                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'UseforIndexingIntoData',LimbID{a}, HoppingRate_ID{b},  HoppingTrialNumber{n},'LastFrameofAbsorption_MoCapSampHz',AnklePower_OthHop_LastFrameofBraking);        
                                    
                            David_DissertationEMGDataStructure =...
                                        setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'UseforIndexingIntoData',LimbID{a}, HoppingRate_ID{b},  HoppingTrialNumber{n},'LastFrameofAbsorption_EMGSampHz',MedGas_LastFrameofBraking_EMGSampHz);        
                                    
                                    
                            
                            
                                    
                                    
                                    
                                    
    %% End n for loop - Hopping Bout
                        end %End n for loop

%%  Add ENTIRE HOP CYCLE Data to Data Structure 
    
    
%TS Contribution to PF Activation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllTSActivity_EntireHopCycle',AllTSActivity_EntireHopCycle);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllPFActivity_EntireHopCycle',AllPFActivity_EntireHopCycle);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TSContributiontoPFActivityEntireHopCycle',TSContributiontoPFActivity_EntireHopCycle);            

%TS Contribution to PF Activation but without Lateral Gas - comparable to Eugene's ratio              

                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSolActivity_EntireHopCycle',MedGasandSolActivity_EntireHopCycle);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSolandPLActivity_EntireHopCycle',MedGasandSolandPLActivity_EntireHopCycle);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSol_ContributiontoPFActivity_EntireHopCycle',MedGasandSolContributiontoPFActivity_EntireHopCycle);        


 %%  Add FLIGHT PHASE Data to Data Structure 
    
%TS Contribution to PF Activation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllTSActivity_FlightPhase',AllTSActivity_FlightPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllPFActivity_FlightPhase',AllPFActivity_FlightPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TSContributiontoPFActivityFlightPhase',TSContributiontoPFActivity_FlightPhase);            

                                

                                
%TS Contribution to PF Activation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSolActivity_FlightPhase',MedGasandSolActivity_FlightPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSolandPLActivity_FlightPhase',MedGasandSolandPLActivity_FlightPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSol_ContributiontoPFActivity_FlightPhase',MedGasandSolContributiontoPFActivity_FlightPhase);                             




 %%  Add CONTACT PHASE Data to Data Structure 
                                
%TS Contribution to PF Activation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllTSActivity_ContactPhase',AllTSActivity_ContactPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllPFActivity_ContactPhase',AllPFActivity_ContactPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TSContributiontoPFActivityContactPhase',TSContributiontoPFActivity_ContactPhase);            

%TS Contribution to PF Activation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSolActivity_ContactPhase',MedGasandSolActivity_ContactPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSolandPLActivity_ContactPhase',MedGasandSolandPLActivity_ContactPhase);
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSol_ContributiontoPFActivity_ContactPhase',MedGasandSolContributiontoPFActivity_ContactPhase);                             

                                
                                
 %%  Add ABSORPTION PHASE Data to Data Structure            


 
                    %Sum of all TS Activity 
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllTSActivity_BrakingPhase',AllTSActivity_BrakingPhase);
                    %Sum of all PF Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllPFActivity_BrakingPhase',AllPFActivity_BrakingPhase);
                    %TS Contribution to PF Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TSContributiontoPFActivity_BrakingPhase',TSContributiontoPFActivity_BrakingPhase);                   
                    %Med Gas and Sol Contributioon to PF Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSol_ContributiontoPFActivity_BrakingPhase',MedGasandSolContributiontoPFActivity_BrakingPhase);    
                    %Med Gas Contribution to TS Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasContributiontoAllTS_BrakingPhase',MedGasContributiontoAllTS_BrakingPhase);    
                        
    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                    %DF-PF Coactivation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TAvsAllPF_CoactivationRatio_BrakingPhase',TAvsAllPF_CoactivationRatio_BrakingPhase);                                                     
    end
                     %Med Gas Contribution to TS Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TwoJointTSvsPL_CoactivationRatio_BrakingPhase',TwoJointTS_Contribution2AllPF_BrakingPhase);                                   
                      %Med Gas Contribution to TS Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'OneJointTSvsPL_CoactivationRatio_BrakingPhase',OneJointTS_Contribution2AllPF_BrakingPhase);                                  

                                
 %%  Add GENERATION PHASE Data to Data Structure            

                    %Sum of all TS Activity 
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllTSActivity_PropulsionPhase',AllTSActivity_BrakingPhase);
                    %Sum of all PF Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'AllPFActivity_PropulsionPhase',AllPFActivity_BrakingPhase);
                    %TS Contribution to PF Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TSContributiontoPFActivity_PropulsionPhase',TSContributiontoPFActivity_BrakingPhase);                   
                    %Med Gas and Sol Contributioon to PF Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasandSol_ContributiontoPFActivity_PropulsionPhase',MedGasandSolContributiontoPFActivity_PropulsionPhase);    
                    %Med Gas Contribution to TS Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'MedGasContributiontoAllTS_PropulsionPhase',MedGasContributiontoAllTS_BrakingPhase);    
    if ~strcmp( ParticipantList{ l }, 'ATx08'  )
                    %DF-PF Coactivation
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TAvsAllPF_CoactivationRatio_PropulsionPhase',TAvsAllPF_CoactivationRatio_BrakingPhase);                                                     
    end
                     %Med Gas Contribution to TS Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'TwoJointTSvsPL_CoactivationRatio_PropulsionPhase',TwoJointTS_Contribution2AllPF_BrakingPhase);                                   
                      %Med Gas Contribution to TS Activity
                    David_DissertationEMGDataStructure =...
                                    setfield(David_DissertationEMGDataStructure,'Post_Quals',GroupList{k}, ParticipantList{l},'IndividualHops',LimbID{a}, 'CoactivationMeasures',HoppingRate_ID{b},  'OneJointTSvsPL_CoactivationRatio_PropulsionPhase',OneJointTS_Contribution2AllPF_BrakingPhase);                                          
                                
                                
                                
                TSContributiontoPFActivityIndicesforOneGroup = find( AllTS_CoactivationRatio(:,1) == k );

                TSContributiontoPFActivityOneGroup = AllTS_CoactivationRatio( TSContributiontoPFActivityIndicesforOneGroup, :);


                TSContributiontoPFActivityIndicesforOneParticipant = find( TSContributiontoPFActivityOneGroup(:,2) == l );

                
                TSContributiontoPFActivityOneParticipant = TSContributiontoPFActivityOneGroup( TSContributiontoPFActivityIndicesforOneParticipant, :);
                
                TSContributiontoPFActivityParticipantMeans( RowtoFill_CoactivationRatio_ParticipantMeans, : ) =...
                    mean(  TSContributiontoPFActivityOneParticipant , 1 );

                RowtoFill_CoactivationRatio_ParticipantMeans = RowtoFill_CoactivationRatio_ParticipantMeans + 1;
                
                
                
                
                TSContributiontoPFActivityIndicesforOneLimb = find( TSContributiontoPFActivityOneParticipant(:, 3) == a);
                TSContributiontoPFActivityOneLimb = TSContributiontoPFActivityOneParticipant (TSContributiontoPFActivityIndicesforOneLimb, :);
                
                
                %Need to change the column number if adding more data columns
                AllTS_CoactivationRatio_IndicesforOneRate = find( TSContributiontoPFActivityOneLimb  (:, 29) == HoppingRate_ID_forTble(b) );
                
                TSContributiontoPFActivityOneRate = TSContributiontoPFActivityOneLimb ( AllTS_CoactivationRatio_IndicesforOneRate, :);
                
                
                
                AllTS_CoactivationRatio_RateMeans( RowtoFill_CoactivationRatio_RateMeans, :) =...
                    mean( TSContributiontoPFActivityOneRate, 1);
                
                 RowtoFill_CoactivationRatio_RateMeans =  RowtoFill_CoactivationRatio_RateMeans + 1;
                                
                                
                 
                                
%% END B For Loop - Hopping RATE                                
                    end



 
%% End A For Loop - Limb ID                
            end%End A For Loop - Limb ID
    
            
%% End l for loop            
        end%End l for loop
    
        
%% End k for loop        
    end %End k for loop
    
    
    
    
%% End j for loop    
end %End j for loop


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end





%% SECTION 4 - INITIALIZE VARIABLES FOR MAX AND MIN TRIAL LENGTHS

%Want to clear the errors for the new section
lasterror = [];

MaxLengthofHopCycle_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MaxLengthofFlightPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MaxLengthofContactPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MaxLengthofBrakingPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MaxLengthofPropulsionPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );

MinLengthofHopCycle_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MinLengthofFlightPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MinLengthofContactPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MinLengthofBrakingPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );
MinLengthofPropulsionPhase_AllHops = NaN( numel( GroupList ) .* numel(ParticipantList) .* numel( HoppingTrialNumber ),1 );


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 4',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end





%% SECTION 5 - FIND MAX TRIAL LENGTHS


%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25' };


%Want to clear the errors for the new section
lasterror = [];


% Begin J For Loop - Create List of All Groups

for j = 1 : numel(QualvsPostQualData)
    
    ListofAllGroups = getfield(David_DissertationEMGDataStructure, QualvsPostQualData{j} );
    
    ElementToFill = 1;

%% Begin K For Loop - Create List of All Participants Within A Given Group

    for k = 1 : numel( GroupList )
        
        ListofParticipants_GroupJ = getfield( ListofAllGroups, GroupList{k} );
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{ k }, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        
        
 %% Begin L For Loop - Create List of Variables within a Given Participant       
        
        for l = 1 : numel(ParticipantList)
            
            ListofDataCategories_ParticipantL = getfield( ListofParticipants_GroupJ, ParticipantList{l} );
           
            ListofVariables_IndexingInParticipantL = getfield( ListofDataCategories_ParticipantL, 'UseforIndexingIntoData' );
            
            ListofVariables_IndividualHops = getfield( ListofDataCategories_ParticipantL, 'IndividualHops' );
            
           
            
            %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %Tbles, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{ l }, 'ATx07'  ) || strcmp( ParticipantList{ l }, 'ATx08'  ) || strcmp( ParticipantList{ l }, 'ATx10'  ) || strcmp( ParticipantList{ l }, 'ATx17'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx18'  ) || strcmp( ParticipantList{ l }, 'ATx21'  ) || strcmp( ParticipantList{ l }, 'ATx25'  ) || strcmp( ParticipantList{ l }, 'ATx36'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx38'  ) || strcmp( ParticipantList{ l }, 'ATx39'  ) || strcmp( ParticipantList{ l }, 'ATx41'  ) || strcmp( ParticipantList{ l }, 'ATx49'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx74'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'ATx24'  )
                
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];




            elseif strcmp( ParticipantList{ l }, 'ATx19'  ) || strcmp( ParticipantList{ l }, 'ATx65'  )
             
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];



            elseif  strcmp( ParticipantList{ l }, 'ATx12'  ) || strcmp( ParticipantList{ l }, 'ATx14'  ) || strcmp( ParticipantList{ l }, 'ATx27'  ) || strcmp( ParticipantList{ l }, 'ATx34'  ) || strcmp( ParticipantList{ l }, 'ATx44'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx50'  ) || strcmp( ParticipantList{ l }, 'ATx100'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ]; 
                
                



            elseif strcmp( ParticipantList{ l }, 'HC11'  ) || strcmp( ParticipantList{n}, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.33 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTble = [ 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'HC17'  ) || strcmp( ParticipantList{ l }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC32'  ) || strcmp( ParticipantList{ l }, 'HC34'  ) || strcmp( ParticipantList{ l }, 'HC45'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC48'  ) ||strcmp( ParticipantList{ l }, 'HC65'  ) || strcmp( ParticipantList{ l }, 'HC68'  )
                
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];


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
                 HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                               
            end
            
            
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ l }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ l }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
            
            
            
            
            
            

 %% Begin A For Loop - Create List of Variables for A Given Limb            
            
            for a = 1 : numel( LimbID )
            
                
                ListofVariables_AthLimbEMG_IndividualHops = getfield( ListofVariables_IndividualHops, LimbID{a} );
                
                IndexingWthinLimbA_IndividualHops = getfield( ListofVariables_IndexingInParticipantL, LimbID{a} );
            
                
                
                    %For ATx18, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle
                     if strcmp( ParticipantList{ l }, 'ATx07'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx07'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx08'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx08'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                         
                     %For ATx10, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx10'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx10 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        

                    %For ATx10, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx10'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx10 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx12'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx12'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx14 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx14, Non-Involved Limb is Right Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx14 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         

                     %For ATx17, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx17'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx17 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx17'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                         
                     %For ATx18, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx18'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx18 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx18'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                     
                        
                        
                    
                         
                         
                     %For ATx19, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx19'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx19'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                     %For ATx21, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx21'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx21'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         

                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx24'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx24'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx25'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx25'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx27'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx27'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx34'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx34'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx36'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx36'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx36 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx38'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx38'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx38 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx39'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx39'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l}, 'ATx41'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l}, 'ATx41'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx44'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx44'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx49'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx49'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx50 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx65'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx65 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx65, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx65'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx65 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx74'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx74'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                         
                         
                    %For the Control group, tell the code that the MuscleID should use 'R' in front
                    %of each muscle for the Right Limb
                    elseif strcmp(LimbID{ a },'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the Left Limb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                     end   

                
                
                    
%% BEGIN B For Loop - Hopping Rate                    
                    
                    for b =  numel( HoppingRate_ID )
                        
                        
                        ListofAllVariables_HoppingRateB = ListofVariables_AthLimbEMG_IndividualHops.( MuscleID{ 1 } ).( HoppingRate_ID{ b } );

                        ListofVariables_CoactivationMeasures_HoppingRateB = getfield( ListofVariables_AthLimbEMG_IndividualHops.CoactivationMeasures, HoppingRate_ID{ b } );
                        
                        
                        IndexingWthinLimbA_HoppingRateB_IndividualHops = getfield( IndexingWthinLimbA_IndividualHops, HoppingRate_ID{ b } );
                        

                        
                        if strcmp( ParticipantList{l}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz' )
                            
                            HoppingTrialNumber = {'Trial1'};
                            

                        elseif strcmp( ParticipantList{l}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )
                            
                            HoppingTrialNumber = {'Trial1','Trial2'};
                            
                            
                        else

                            HoppingTrialNumber = {'Trial1'};
                            
                        end            
                        
                        
%% Begin N For Loop - Create List of Variables for A Given Hopping Bout             


                    
                        for n = 1: numel( HoppingTrialNumber )


                            ListofCoactivationVariables_HoppingTrialN = getfield( ListofVariables_CoactivationMeasures_HoppingRateB, HoppingTrialNumber{n} );

                            HoppingEMG_IndividualHops_TrialP = getfield( ListofAllVariables_HoppingRateB, HoppingTrialNumber{n} );

                            IndexingWthinLimbA_HoppingRateB_TrialN_IndividualHops = getfield( IndexingWthinLimbA_HoppingRateB_IndividualHops, HoppingTrialNumber{n} );


                            ViggianiBarrett_PFCommonality_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_EntireHopCycle;
                            ViggianiBarrett_PFActivity_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_EntireHopCycle;
                            ViggianiBarrett_PFCoactivation_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_EntireHopCycle;


                            ViggianiBarrett_PFCommonality_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_FlightPhase;
                            ViggianiBarrett_PFActivity_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_FlightPhase;
                            ViggianiBarrett_PFCoactivation_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_FlightPhase;

                            ViggianiBarrett_PFCommonality_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_ContactPhase;
                            ViggianiBarrett_PFActivity_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_ContactPhase;
                            ViggianiBarrett_PFCoactivation_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_ContactPhase;
                            
                            ViggianiBarrett_PFCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_BrakingPhase;
                            ViggianiBarrett_PFActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_BrakingPhase;
                            ViggianiBarrett_PFCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_BrakingPhase;
                            
                            ViggianiBarrett_PFCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_PropulsionPhase;
                            ViggianiBarrett_PFActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_PropulsionPhase;
                            ViggianiBarrett_PFCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_PropulsionPhase;






                            %ATx08 Involved Limb doesn't have DFPF commonality because Involved Limb TA isn't usable
                            if ~strcmp( ParticipantList{ l }, 'ATx08'  ) && ~strcmp( LimbID{ a }, 'InvolvedLimb' )
    
                                ViggianiBarrett_DFPFCommonality_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_EntireHopCycle;
                                ViggianiBarrett_DFPFActivity_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_EntireHopCycle;
                                ViggianiBarrett_DFPFCoactivation_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_EntireHopCycle;
    
    
                                ViggianiBarrett_DFPFCommonality_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_FlightPhase;
                                ViggianiBarrett_DFPFActivity_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_FlightPhase;
                                ViggianiBarrett_DFPFCoactivation_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_FlightPhase;
    
                                ViggianiBarrett_DFPFCommonality_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_ContactPhase;
                                ViggianiBarrett_DFPFActivity_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_ContactPhase;
                                ViggianiBarrett_DFPFCoactivation_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_ContactPhase;
                                
                                ViggianiBarrett_DFPFCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_BrakingPhase;
                                ViggianiBarrett_DFPFActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_BrakingPhase;
                                ViggianiBarrett_DFPFCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_BrakingPhase;
                                
                                ViggianiBarrett_DFPFCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_PropulsionPhase;
                                ViggianiBarrett_DFPFActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_PropulsionPhase;
                                ViggianiBarrett_DFPFCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_PropulsionPhase;
    
    
                            end


                            ViggianiBarrett_TSCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCommonality_BrakingPhase;
                            ViggianiBarrett_TSActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSActivity_BrakingPhase;
                            ViggianiBarrett_TSCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCoactivation_BrakingPhase;
                            
                            ViggianiBarrett_TSCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCommonality_PropulsionPhase;
                            ViggianiBarrett_TSActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSActivity_PropulsionPhase;
                            ViggianiBarrett_TSCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCoactivation_PropulsionPhase;
                            
                            





                            MaxLengthofHopCycle_AllHops(ElementToFill) = max( IndexingWthinLimbA_HoppingRateB_IndividualHops.LengthofEntireHopCycle_Truncated_EMGSamplingHz );
                            MaxLengthofFlightPhase_AllHops(ElementToFill) = max( IndexingWthinLimbA_HoppingRateB_IndividualHops.LengthofFlightPhase_Truncated_EMGSamplingHz );
                            MaxLengthofContactPhase_AllHops(ElementToFill) = max( IndexingWthinLimbA_HoppingRateB_IndividualHops.LengthofContactPhase_EMGSamplingHz );
                            MaxLengthofBrakingPhase_AllHops(ElementToFill) = max(  IndexingWthinLimbA_HoppingRateB_TrialN_IndividualHops.LengthofBrakingPhase_EMGSampHz );
                            MaxLengthofPropulsionPhase_AllHops(ElementToFill) = max(  IndexingWthinLimbA_HoppingRateB_TrialN_IndividualHops.LengthofPropulsionPhase_NonTruncated_EMGSampHz );
                            
                            MinLengthofHopCycle_AllHops(ElementToFill) = min( IndexingWthinLimbA_HoppingRateB_IndividualHops.LengthofEntireHopCycle_Truncated_EMGSamplingHz );
                            MinLengthofFlightPhase_AllHops(ElementToFill) = min( IndexingWthinLimbA_HoppingRateB_IndividualHops.LengthofFlightPhase_Truncated_EMGSamplingHz );
                            MinLengthofContactPhase_AllHops(ElementToFill) = min( IndexingWthinLimbA_HoppingRateB_IndividualHops.LengthofContactPhase_EMGSamplingHz );
                            MinLengthofBrakingPhase_AllHops(ElementToFill) = min(  IndexingWthinLimbA_HoppingRateB_TrialN_IndividualHops.LengthofBrakingPhase_EMGSampHz );
                            MinLengthofPropulsionPhase_AllHops(ElementToFill) = min(  IndexingWthinLimbA_HoppingRateB_TrialN_IndividualHops.LengthofPropulsionPhase_NonTruncated_EMGSampHz );

                            ElementToFill = ElementToFill + 1;


    %% End N For Loop  
                        end

    %% End B For Loop  
    
                    end

                
%% End A For Loop                
            end
            
%% End L For Loop            
        end
        
%% End K For Loop        
    end
    
    MaxHopCycleLength_AllParticipants = max( MaxLengthofHopCycle_AllHops );
    
    MaxFlightPhaseLength_AllParticipants = max( MaxLengthofFlightPhase_AllHops );
    
    MaxContactPhaseLength_AllParticipants = max( MaxLengthofContactPhase_AllHops );
    
    MaxBrakingPhaseLength_AllParticipants = max( MaxLengthofBrakingPhase_AllHops );
    
    MaxPropulsionPhaseLength_AllParticipants = max( MaxLengthofPropulsionPhase_AllHops );
    
    
    MinHopCycleLength_AllParticipants = min( MinLengthofHopCycle_AllHops );
    
    MinFlightPhaseLength_AllParticipants = min( MinLengthofFlightPhase_AllHops );
    
    MinContactPhaseLength_AllParticipants = min( MinLengthofContactPhase_AllHops );
    
    MinBrakingPhaseLength_AllParticipants = min( MinLengthofBrakingPhase_AllHops );
    
    MinPropulsionPhaseLength_AllParticipants = min( MinLengthofPropulsionPhase_AllHops );
    
% End J For Loop    
end

if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 5',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end






%% SECTION 6 - INTERPOLATE VIGGIANI AND BARRETT COACTIVATION MEASURES

%Initialize Tbles that will be exported to R
ViggianiBarrett_Coactivation_EntireHopCycle_forR = NaN( 1, 1);
ViggianiBarrett_Coactivation_FlightPhase_forR = NaN( 1, 1);
ViggianiBarrett_Coactivation_ContactPhase_forR = NaN( 1, 1);
ViggianiBarrett_Coactivation_Braking_forR = NaN( 1, 1);
ViggianiBarrett_Coactivation_Propulsion_forR = NaN( 1, 1);
ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR = NaN( 1, 1);
ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR = NaN( 1, 1);
ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR = NaN( 1, 1);
ViggianiBarrett_DFPF_Coactivation_Braking_forR = NaN( 1, 1);
ViggianiBarrett_DFPF_Coactivation_Propulsion_forR = NaN( 1, 1);
ViggianiBarrett_TS_Coactivation_Braking_forR = NaN( 1, 1);
ViggianiBarrett_TS_Coactivation_Propulsion_forR = NaN( 1, 1);
ViggianiBarrett_2JntTS_Coactivation_Braking_forR = NaN( 1, 1);
ViggianiBarrett_2JntTS_Coactivation_Propulsion_forR = NaN( 1, 1);
ViggianiBarrett_1JntTS_Coactivation_Braking_forR = NaN( 1, 1);
ViggianiBarrett_1JntTS_Coactivation_Propulsion_forR = NaN( 1, 1);



%Want to clear the errors for the new section
lasterror = [];

% Begin For Loop - Create List of All Groups

for j = 1 : numel(QualvsPostQualData)
    
    ListofAllGroups = getfield(David_DissertationEMGDataStructure, QualvsPostQualData{j} );

%% Begin K For Loop - Create List of All Participants Within A Given Group

    for k = 1: numel( GroupList )
        
        RowtoFill_OnePerGroup = 1;

        RowtoFill_OnePerGroup_FlightPhase = 1;

        RowtoFill_OnePerGroup_ContactPhase = 1;

        
        ViggianiBarrett_Coactivation_EntireHopCycle_GroupMeans = NaN(1,10);
        ViggianiBarrett_Coactivation_FlightPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_Coactivation_ContactPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_Coactivation_Braking_GroupMeans = NaN(1,10);
        ViggianiBarrett_Coactivation_Propulsion_GroupMeans = NaN(1,10);
        
        
        ViggianiBarrett_GasMedContribution_BrakingPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_GasMedContribution_PropulsionPhase_GroupMeans = NaN(1,10);
        
        ViggianiBarrett_2JntTSvsPF_BrakingPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_1JntTSvsPF_BrakingPhase_GroupMeans = NaN(1,10);
        
        ViggianiBarrett_2JntTSvsPF_PropulsionPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_1JntTSvsPF_PropulsionPhase_GroupMeans = NaN(1,10);
        
        
        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_GroupMeans = NaN(1,10);
        ViggianiBarrett_DFPF_Coactivation_FlightPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_DFPF_Coactivation_ContactPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_DFPF_Coactivation_BrakingPhase_GroupMeans = NaN(1,10);
        ViggianiBarrett_DFPF_Coactivation_PropulsionPhase_GroupMeans = NaN(1,10);
        
        
        
        
        ListofParticipants_GroupJ = getfield( ListofAllGroups, GroupList{k} );
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{ k }, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        
        
 %% Begin L For Loop - Create List of Variables for a Given Participant      
        
        for l = 1 : numel(ParticipantList)

            RowtoFill_OnePerParticipant = 1;

            RowtoFill_OnePerParticipant_FlightPhase = 1;

            RowtoFill_OnePerParticipant_ContactPhase = 1;
            
            
            
            
            ViggianiBarrett_Coactivation_EntireHopCycle_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_Coactivation_FlightPhase_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_Coactivation_ContactPhase_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_Coactivation_Braking_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_Coactivation_Propulsion_ParticipantMeans = NaN(1,10);


            ViggianiBarrett_GasMedContribution_Braking_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_GasMedContribution_Propulsion_ParticipantMeans = NaN(1,10);
            
            
            ViggianiBarrett_2JntTSvsPF_BrakingPhase_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_1JntTSvsPF_BrakingPhase_ParticipantMeans = NaN(1,10);

            ViggianiBarrett_2JntTSvsPF_PropulsionPhase_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_1JntTSvsPF_PropulsionPhase_ParticipantMeans = NaN(1,10);
            
            
            
            ViggianiBarrett_DFPF_Coactivation_EntireHop_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_DFPF_Coactivation_FlightPhase_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_DFPF_Coactivation_ContactPhase_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_DFPF_Coactivation_Braking_ParticipantMeans = NaN(1,10);
            ViggianiBarrett_DFPF_Coactivation_Propulsion_PariticpantMeans = NaN(1,10);

            
            
            ListofDataCategories_ParticipantL = getfield( ListofParticipants_GroupJ, ParticipantList{l} );
            
            ListofVariables_IndividualHops = getfield( ListofDataCategories_ParticipantL, 'IndividualHops' );
            

            ListofVariables_IndexingInParticipantL = getfield( ListofDataCategories_ParticipantL, 'UseforIndexingIntoData' );

            
%% Set Limb ID, Hopping Rate

             %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %Tbles, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{ l }, 'ATx07'  ) || strcmp( ParticipantList{ l }, 'ATx08'  ) || strcmp( ParticipantList{ l }, 'ATx10'  ) || strcmp( ParticipantList{ l }, 'ATx17'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx18'  ) || strcmp( ParticipantList{ l }, 'ATx21'  ) || strcmp( ParticipantList{ l }, 'ATx25'  ) || strcmp( ParticipantList{ l }, 'ATx36'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx38'  ) || strcmp( ParticipantList{ l }, 'ATx39'  ) || strcmp( ParticipantList{ l }, 'ATx41'  ) || strcmp( ParticipantList{ l }, 'ATx49'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx74'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'ATx24'  ) 
                
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];




            elseif strcmp( ParticipantList{ l }, 'ATx19'  ) || strcmp( ParticipantList{ l }, 'ATx65'  )
             
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];



            elseif strcmp( ParticipantList{ l }, 'ATx12'  ) || strcmp( ParticipantList{ l }, 'ATx14'  ) || strcmp( ParticipantList{ l }, 'ATx27'  ) || strcmp( ParticipantList{ l }, 'ATx34'  ) || strcmp( ParticipantList{ l }, 'ATx44'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx50'  ) || strcmp( ParticipantList{ l }, 'ATx100'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ]; 
                
                



            elseif strcmp( ParticipantList{ l }, 'HC11'  ) || strcmp( ParticipantList{n}, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.33 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTble = [ 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'HC17'  ) || strcmp( ParticipantList{ l }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC32'  ) || strcmp( ParticipantList{ l }, 'HC34'  ) || strcmp( ParticipantList{ l }, 'HC45'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC48'  ) ||strcmp( ParticipantList{ l }, 'HC65'  ) || strcmp( ParticipantList{ l }, 'HC68'  )
                
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];


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
                 HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                               
            end
            
            
            
            
            %Participants HP08 has MoCap sampling Hz of 150 instead of 250
            if strcmp( ParticipantList{ l }, 'HP08' )
                
                MoCapSampHz = 150;
                
            elseif strcmp( ParticipantList{ l }, 'HP02' )
                
                MoCapSampHz = 300;    
                
            else
                
                MoCapSampHz = 250;
                
            end
            
            
            
            
 %% Begin A For Loop - Create List of Variables for A Given Limb
 
           for a = 1 : numel( LimbID )
            
                RowtoFill_OnePerLimb = 1;

                RowtoFill_OnePerLimb_FlightPhase = 1;

                RowtoFill_OnePerLimb_ContactPhase = 1;
                
                
                
                ViggianiBarrett_Coactivation_EntireHopCycle_LimbMeans = NaN(1,10);
                ViggianiBarrett_Coactivation_FlightPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_Coactivation_ContactPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_Coactivation_Braking_LimbMeans = NaN(1,10);
                ViggianiBarrett_Coactivation_Propulsion_LimbMeans = NaN(1,10);


                ViggianiBarrett_GasMedContribution_BrakingPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_GasMedContribution_PropulsionPhase_LimbMeans = NaN(1,10);
                
                
                ViggianiBarrett_2JntTSvsPF_BrakingPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_1JntTSvsPF_BrakingPhase_LimbMeans = NaN(1,10);

                ViggianiBarrett_2JntTSvsPF_PropulsionPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_1JntTSvsPF_PropulsionPhase_LimbMeans = NaN(1,10);
                
                
                
                
                ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_LimbMeans = NaN(1,10);
                ViggianiBarrett_DFPF_Coactivation_FlightPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_DFPF_Coactivation_ContactPhase_LimbMeans = NaN(1,10);
                ViggianiBarrett_DFPF_Coactivation_Braking_LimbMeans = NaN(1,10);
                ViggianiBarrett_DFPF_Coactivation_PropulsionPhase_LimbMeans = NaN(1,10);
                
                
                
                
                 %For ATx07, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                   if strcmp( ParticipantList{ l }, 'ATx07'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx07'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx08'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL' };
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx08'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                         
                     %For ATx10, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx10'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx10 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        

                    %For ATx10, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx10'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx10 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx12'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx12'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx14 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx14, Non-Involved Limb is Right Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx14'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx14 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         

                     %For ATx17, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx17'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx17 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx17'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                         
                     %For ATx18, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx18'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx18 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx18'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                     
                        
                        
                    
                         
                         
                     %For ATx19, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx19'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx19'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                     %For ATx21, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx21'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx21'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         

                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx24'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{ l }, 'ATx24'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx25'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx25'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx27'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx27'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx34'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx34'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx36'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx36'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx36 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};




                    elseif strcmp( ParticipantList{ l }, 'ATx38'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx38'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx38 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx39'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx39'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{l}, 'ATx41'  ) && strcmp( LimbID{a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{l}, 'ATx41'  ) && strcmp( LimbID{a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx44'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx44'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx49'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx49'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx50'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx50 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx65'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx65 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx65, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx65'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx65 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{ l }, 'ATx74'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{ l }, 'ATx74'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                         
                         
                    %For the Control group, tell the code that the MuscleID should use 'R' in front
                    %of each muscle for the Right Limb
                    elseif strcmp(LimbID{ a },'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the Left Limb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                   end 
                    
                     
                     
                    

               
                ListofVariables_AthLimbEMG_IndividualHops = getfield( ListofVariables_IndividualHops, LimbID{a} );
                
                IndexingWthinLimbA_IndividualHops = getfield( ListofVariables_IndexingInParticipantL, LimbID{a} );



                    RowtoFill_OnePerMTU = 1;

                    RowtoFill_OnePerMTU_FlightPhase = 1;

                    RowtoFill_OnePerMTU_ContactPhase = 1;

                    

                    

                    
 %% BEGIN B For Loop - Hopping Rate                   
                    
                    
                    for b = numel( HoppingRate_ID)
                        

                        
                        ViggianiBarrett_Coactivation_EntireHopCycle_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_Coactivation_ContactPhase_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_Coactivation_FlightPhase_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_Coactivation_Braking_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_Coactivation_Propulsion_RATEMeans = NaN(3, 10);
                        
                        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_DFPF_Coactivation_ContactPhase_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_DFPF_Coactivation_FlightPhase_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_DFPF_Coactivation_Braking_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_DFPF_Coactivation_Propulsion_RATEMeans = NaN(3, 10);
                        
                        ViggianiBarrett_TS_Coactivation_Braking_RATEMeans = NaN(3, 10);
                        ViggianiBarrett_TS_Coactivation_Propulsion_RATEMeans = NaN(3, 10);
                        
                     

                        ViggianiBarrett_2JntTS_Coactivation_Braking_RATEMeans = NaN(1,10);
                        ViggianiBarrett_1JntTS_Coactivation_Braking_RATEMeans = NaN(1,10);

                        ViggianiBarrett_2JntTS_Coactivation_Propulsion_RATEMeans = NaN(1,10);
                        ViggianiBarrett_1JntTS_Coactivation_Propulsion_RATEMeans = NaN(1,10);                       
                        
                        
                        
                        RowtoFill_OnePerRate = 1;

                        RowtoFill_OnePerRate_FlightPhase = 1;

                        RowtoFill_OnePerRate_ContactPhase = 1;
                        
                        RowtoFill_OnePerRate_BrakingPhase = 1;
                        
                        RowtoFill_OnePerRate_PropulsionPhase = 1;
                        
                        
                        
                        ListofVariables_CoactivationMeasures_HoppingRateB = getfield( ListofVariables_AthLimbEMG_IndividualHops.CoactivationMeasures, HoppingRate_ID{ b } );
                        
                        IndexingWthinHoppingRateB = getfield( IndexingWthinLimbA_IndividualHops, HoppingRate_ID{b} );



                        
                        
                        %Pull out the lengths of the entire hop cycle, contact phase, flight phase,
                        %braking phase, and propulsion phase for all hops. We will use these to tell
                        %the code how many data points to access for a given hop. Example: Hop 1 may
                        %be 10 data points but Hop 11 may be 12 data points
                        LengthofHopCycle_AllHops = IndexingWthinHoppingRateB.LengthofEntireHopCycle_Truncated_EMGSamplingHz;
                        
                        LengthofContactPhase_AllHops = IndexingWthinHoppingRateB.LengthofContactPhase_EMGSamplingHz;
                        
                        LengthofFlightPhase_AllHops = IndexingWthinHoppingRateB.LengthofFlightPhase_Truncated_EMGSamplingHz;
                        
                        

                        
                            if strcmp( ParticipantList{l}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoHz' )
                                
                                HoppingTrialNumber = {'Trial1'};
                                

                            elseif strcmp( ParticipantList{l}, 'ATx01'  ) && strcmp( HoppingRate_ID{b}, 'TwoPoint3Hz' )
                                
                                HoppingTrialNumber = {'Trial1','Trial2'};
                                
                                
                            else

                                HoppingTrialNumber = {'Trial1'};
                                
                            end   
                        
                        
                        
  %% Begin N For Loop - Create List of Variables for A Given Hopping Bout                     
                    
                        for n = 1: numel( HoppingTrialNumber )



                            %Use getfield to create a new data structure containing the EMG data for
                            %the pth hopping trial
                            HoppingEMG_IndividualHops_TrialP = getfield( HoppingEMG_IndividualHops_HoppingRateB_DataStructure,HoppingTrialNumber{ n } );

                            %Create new data structure containing the indexing data for Limb A, Hopping
                            %Rate B, Trial N
                            Indexing_HoppingRateB_TrialN = IndexingWthinHoppingRateB.( HoppingTrialNumber{ n } );
                        
                            %Pull out the length of the braking phase for all hops
                            LengthofBrakingPhase_AllHops = Indexing_HoppingRateB_TrialN.LengthofBrakingPhase_EMGSampHz;
                            
                            %Pull out the length of the propuslion phase for all hops
                            LengthofPropulsionPhase_AllHops = Indexing_HoppingRateB_TrialN.LengthofPropulsionPhase_NonTruncated_EMGSampHz;


                            RowtoFill_OnePerBout = 1;

                            RowtoFill_OnePerBout_FlightPhase = 1;

                            RowtoFill_OnePerBout_ContactPhase = 1;




                            ViggianiBarrett_Coactivation_EntireHopCycle_BoutMeans = NaN(1,10);
                            ViggianiBarrett_Coactivation_FlightPhase_BoutMeans = NaN(1,10);
                            ViggianiBarrett_Coactivation_ContactPhase_BoutMeans = NaN(1,10);
                            ViggianiBarrett_Coactivation_Braking_BoutMeans = NaN(1,10);
                            ViggianiBarrett_Coactivation_Propulsion_BoutMeans = NaN(1,10);


                            ViggianiBarrett_GasMedContribution_BrakingPhase_BoutMeans = NaN(1,10);
                            ViggianiBarrett_GasMedContribution_PropulsionPhase_BoutMeans = NaN(1,10);




                            ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_BoutMeans = NaN(1,10);
                            ViggianiBarrett_DFPF_Coactivation_FlightPhase_BoutMeans = NaN(1,10);
                            ViggianiBarrett_DFPF_Coactivation_ContactPhase_BoutMeans = NaN(1,10);
                            ViggianiBarrett_DFPF_Coactivation_Braking_BoutMeans = NaN(1,10);
                            ViggianiBarrett_DFPF_Coactivation_PropulsionPhase_BoutMeans = NaN(1,10);







                            ListofCoactivationVariables_HoppingTrialN = getfield( ListofVariables_CoactivationMeasures_HoppingRateB, HoppingTrialNumber{ n } );


                            ViggianiBarrett_PFCommonality_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_EntireHopCycle;
                            ViggianiBarrett_PFActivity_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_EntireHopCycle;
                            ViggianiBarrett_PFCoactivation_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_EntireHopCycle;


                            ViggianiBarrett_PFCommonality_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_FlightPhase;
                            ViggianiBarrett_PFActivity_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_FlightPhase;
                            ViggianiBarrett_PFCoactivation_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_FlightPhase;

                            ViggianiBarrett_PFCommonality_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_ContactPhase;
                            ViggianiBarrett_PFActivity_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_ContactPhase;
                            ViggianiBarrett_PFCoactivation_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_ContactPhase;

                            
                             ViggianiBarrett_PFCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_BrakingPhase;
                            ViggianiBarrett_PFActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_BrakingPhase;
                            ViggianiBarrett_PFCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_BrakingPhase;

                            
                            ViggianiBarrett_PFCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCommonality_PropulsionPhase;
                            ViggianiBarrett_PFActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFActivity_PropulsionPhase;
                            ViggianiBarrett_PFCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_PFCoactivation_PropulsionPhase;

                            
                            
                            
                            %Two Joint TS vs all PF - Absorption Phase
                             ViggianiBarrett_2JntTSCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_2JntTSCommonality_BrakingPhase;
                            ViggianiBarrett_2JntTSActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_2JntTSActivity_BrakingPhase;
                            ViggianiBarrett_2JntTSCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_2JntTSCoactivation_BrakingPhase;

                            
                            %Two Joint TS vs all PF - Generation Phase
                             ViggianiBarrett_2JntTSCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_2JntTSCommonality_PropulsionPhase;
                            ViggianiBarrett_2JntTSActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_2JntTSActivity_PropulsionPhase;
                            ViggianiBarrett_2JntTSCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_2JntTSCoactivation_PropulsionPhase;                            
                            
                            
                            %One Joint TS vs all PF - Absorption Phase
                            ViggianiBarrett_1JntTSCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_1JntTSCommonality_BrakingPhase;
                            ViggianiBarrett_1JntTSActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_1JntTSActivity_BrakingPhase;
                            ViggianiBarrett_1JntTSCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_1JntTSCoactivation_BrakingPhase;                            
                            
                            %One Joint TS vs all PF - Generation Phase
                            ViggianiBarrett_1JntTSCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_1JntTSCommonality_PropulsionPhase;
                            ViggianiBarrett_1JntTSActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_1JntTSActivity_PropulsionPhase;
                            ViggianiBarrett_1JntTSCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_1JntTSCoactivation_PropulsionPhase;

                            
                            
                            
                            %DF-PF Coactivation
                            
                                %Entire Hop Cycle
                            ViggianiBarrett_DFPFCommonality_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_EntireHopCycle;
                            ViggianiBarrett_DFPFActivity_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_EntireHopCycle;
                            ViggianiBarrett_DFPFCoactivation_EntireHopCycle = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_EntireHopCycle;

                                %Flight Phase Only
                            ViggianiBarrett_DFPFCommonality_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_FlightPhase;
                            ViggianiBarrett_DFPFActivity_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_FlightPhase;
                            ViggianiBarrett_DFPFCoactivation_FlightPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_FlightPhase;

                                %Contact Phase Only
                            ViggianiBarrett_DFPFCommonality_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_ContactPhase;
                            ViggianiBarrett_DFPFActivity_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_ContactPhase;
                            ViggianiBarrett_DFPFCoactivation_ContactPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_ContactPhase;

                                %Absorption Phase Only
                             ViggianiBarrett_DFPFCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_BrakingPhase;
                            ViggianiBarrett_DFPFActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_BrakingPhase;
                            ViggianiBarrett_DFPFCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_BrakingPhase;

                                %Generation Phase Only
                            ViggianiBarrett_DFPFCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCommonality_PropulsionPhase;
                            ViggianiBarrett_DFPFActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFActivity_PropulsionPhase;
                            ViggianiBarrett_DFPFCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_DFPFCoactivation_PropulsionPhase;


                            
                            
                            
                            
                            
                            %TS Only - Absorption Phase
                            ViggianiBarrett_TSCommonality_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCommonality_BrakingPhase;
                            ViggianiBarrett_TSActivity_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSActivity_BrakingPhase;
                            ViggianiBarrett_TSCoactivation_BrakingPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCoactivation_BrakingPhase;

                            %TS Only - Generation Phase
                            ViggianiBarrett_TSCommonality_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCommonality_PropulsionPhase;
                            ViggianiBarrett_TSActivity_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSActivity_PropulsionPhase;
                            ViggianiBarrett_TSCoactivation_PropulsionPhase = ListofCoactivationVariables_HoppingTrialN.ViggianiBarrett_TSCoactivation_PropulsionPhase;
                            
                            




                            NumberofHops = size( GasMed_NormalizedEMG_LimbA_TrialN, 2 );
                            
                            
                            
                            
 %Begin O For Loop - One Loop Per Hop                           
                            for o = 1 : size(  ViggianiBarrett_PFCommonality_EntireHopCycle, 2)

                                %Create time vector - length = length of Oth hop. Will use this for
                                %interpolating coactivation data to be the same length. Will do this
                                %for entire hop cycle, flight phase, entire contact phase,
                                %generation phase, absorption phase
                                TimeVector_EntireHopCycle_CurrentTrialLength = linspace(0, 100,  LengthofHopCycle_AllHops (o) ); 

                                TimeVector_FlightPhase_CurrentTrialLength = linspace(0, 100, LengthofFlightPhase_AllHops(o) ); 

                                TimeVector_ContactPhase_CurrentTrialLength = linspace(0, 100, LengthofContactPhase_AllHops(o) ); 

                                TimeVector_Braking_CurrentTrialLength = linspace(0, 100, LengthofBrakingPhase_AllHops(o) ); 
                                
                                 TimeVector_Propulsion_CurrentTrialLength = linspace(0, 100, LengthofPropulsionPhase_AllHops(o) ); 
                                 
                                 
                                 
                                 
                                 
                                %Create time vector - length = maximum length across all participants. Will use this for
                                %interpolating coactivation data to be the same length. Will do this for entire hop cycle, flight phase, entire contact phase,
                                %generation phase, absorption phase.
                                TimeVector_EntireHopCycle_DesiredTrialLength = linspace(0, 100, MaxHopCycleLength_AllParticipants ); 

                                TimeVector_FlightPhase_DesiredTrialLength = linspace(0, 100, MaxFlightPhaseLength_AllParticipants );

                                TimeVector_ContactPhase_DesiredTrialLength = linspace(0, 100, MaxContactPhaseLength_AllParticipants );

                                TimeVector_Braking_DesiredTrialLength = linspace(0, 100, MaxBrakingPhaseLength_AllParticipants );
                                
                                TimeVector_Propulsion_DesiredTrialLength = linspace(0, 100, MaxPropulsionPhaseLength_AllParticipants );                                
                                

                                
                                
                                %Interpolate PF Coactivation Data for Entire Hop Cycle
                                ViggianiBarrett_PFCommonality_EntireHopCycle_Interpolated( 1 : MaxHopCycleLength_AllParticipants ) = interp1( TimeVector_EntireHopCycle_CurrentTrialLength,...
                                    ViggianiBarrett_PFCommonality_EntireHopCycle( 1: LengthofHopCycle_AllHops (o), o ),  TimeVector_EntireHopCycle_DesiredTrialLength);

                                ViggianiBarrett_PFActivity_EntireHopCycle_Interpolated( 1 : MaxHopCycleLength_AllParticipants ) = interp1( TimeVector_EntireHopCycle_CurrentTrialLength,...
                                    ViggianiBarrett_PFActivity_EntireHopCycle( 1: LengthofHopCycle_AllHops (o), o ),  TimeVector_EntireHopCycle_DesiredTrialLength);

                                ViggianiBarrett_PFCoactivation_EntireHopCycle_Interpolated( 1 : MaxHopCycleLength_AllParticipants ) = interp1( TimeVector_EntireHopCycle_CurrentTrialLength,...
                                    ViggianiBarrett_PFCoactivation_EntireHopCycle( 1: LengthofHopCycle_AllHops (o), o ),  TimeVector_EntireHopCycle_DesiredTrialLength);

                                
                                

                                 %Interpolate PF Coactivation Data for Flight Phase              
                                ViggianiBarrett_PFCommonality_FlightPhase_Interpolated( 1 : MaxFlightPhaseLength_AllParticipants ) = interp1( TimeVector_FlightPhase_CurrentTrialLength,...
                                    ViggianiBarrett_PFCommonality_FlightPhase( 1:LengthofFlightPhase_AllHops(o), o ),  TimeVector_FlightPhase_DesiredTrialLength);

                                ViggianiBarrett_PFActivity_FlightPhase_Interpolated( 1 : MaxFlightPhaseLength_AllParticipants ) = interp1( TimeVector_FlightPhase_CurrentTrialLength,...
                                    ViggianiBarrett_PFActivity_FlightPhase( 1:LengthofFlightPhase_AllHops(o), o ),  TimeVector_FlightPhase_DesiredTrialLength);

                                ViggianiBarrett_PFCoactivation_FlightPhase_Interpolated( 1 : MaxFlightPhaseLength_AllParticipants ) = interp1( TimeVector_FlightPhase_CurrentTrialLength,...
                                    ViggianiBarrett_PFCoactivation_FlightPhase( 1:LengthofFlightPhase_AllHops(o), o ),  TimeVector_FlightPhase_DesiredTrialLength);



                                %Interpolate PF Coactivation Data for Entire Contact Phase
                                ViggianiBarrett_PFCommonality_ContactPhase_Interpolated( 1 : MaxContactPhaseLength_AllParticipants ) = interp1( TimeVector_ContactPhase_CurrentTrialLength,...
                                    ViggianiBarrett_PFCommonality_ContactPhase( 1:LengthofContactPhase_AllHops(o), o ),  TimeVector_ContactPhase_DesiredTrialLength);

                                ViggianiBarrett_PFActivity_ContactPhase_Interpolated( 1 : MaxContactPhaseLength_AllParticipants ) = interp1( TimeVector_ContactPhase_CurrentTrialLength,...
                                    ViggianiBarrett_PFActivity_ContactPhase( 1:LengthofContactPhase_AllHops(o), o ),  TimeVector_ContactPhase_DesiredTrialLength);

                                ViggianiBarrett_PFCoactivation_ContactPhase_Interpolated( 1 : MaxContactPhaseLength_AllParticipants ) = interp1( TimeVector_ContactPhase_CurrentTrialLength,...
                                    ViggianiBarrett_PFCoactivation_ContactPhase( 1:LengthofContactPhase_AllHops(o), o ),  TimeVector_ContactPhase_DesiredTrialLength);


                                
                                
                                %Interpolate PF Coactivation Data for Absorption Phase                            
                                ViggianiBarrett_PFCommonality_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_PFCommonality_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_PFActivity_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_PFActivity_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_PFCoactivation_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_PFCoactivation_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                
                                %Interpolate PF Coactivation Data for Generation Phase
                                ViggianiBarrett_PFCommonality_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_PFCommonality_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_PFActivity_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_PFActivity_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_PFCoactivation_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_PFCoactivation_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);



                                
                                
                                
                                
                                
                                
                                

                                %Interpolate DF-PF Coactivation Data for Entire Hop Cycle
                                ViggianiBarrett_DFPFCommonality_EntireHopCycle_Interpolated( 1 : MaxHopCycleLength_AllParticipants ) = interp1( TimeVector_EntireHopCycle_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCommonality_EntireHopCycle( 1: LengthofHopCycle_AllHops (o), o ),  TimeVector_EntireHopCycle_DesiredTrialLength);

                                ViggianiBarrett_DFPFActivity_EntireHopCycle_Interpolated( 1 : MaxHopCycleLength_AllParticipants ) = interp1( TimeVector_EntireHopCycle_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFActivity_EntireHopCycle( 1: LengthofHopCycle_AllHops (o), o ),  TimeVector_EntireHopCycle_DesiredTrialLength);

                                ViggianiBarrett_DFPFCoactivation_EntireHopCycle_Interpolated( 1 : MaxHopCycleLength_AllParticipants ) = interp1( TimeVector_EntireHopCycle_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCoactivation_EntireHopCycle( 1: LengthofHopCycle_AllHops (o), o ),  TimeVector_EntireHopCycle_DesiredTrialLength);


                                %Interpolate DF-PF Coactivation Data for Flight Phase
                                ViggianiBarrett_DFPFCommonality_FlightPhase_Interpolated( 1 : MaxFlightPhaseLength_AllParticipants ) = interp1( TimeVector_FlightPhase_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCommonality_FlightPhase( 1:LengthofFlightPhase_AllHops(o), o ),  TimeVector_FlightPhase_DesiredTrialLength);

                                ViggianiBarrett_DFPFActivity_FlightPhase_Interpolated( 1 : MaxFlightPhaseLength_AllParticipants ) = interp1( TimeVector_FlightPhase_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFActivity_FlightPhase( 1:LengthofFlightPhase_AllHops(o), o ),  TimeVector_FlightPhase_DesiredTrialLength);

                                ViggianiBarrett_DFPFCoactivation_FlightPhase_Interpolated( 1 : MaxFlightPhaseLength_AllParticipants ) = interp1( TimeVector_FlightPhase_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCoactivation_FlightPhase( 1:LengthofFlightPhase_AllHops(o), o ),  TimeVector_FlightPhase_DesiredTrialLength);



                                %Interpolate DF-PF Coactivation Data for Contact Phase
                                ViggianiBarrett_DFPFCommonality_ContactPhase_Interpolated( 1 : MaxContactPhaseLength_AllParticipants ) = interp1( TimeVector_ContactPhase_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCommonality_ContactPhase( 1:LengthofContactPhase_AllHops(o), o ),  TimeVector_ContactPhase_DesiredTrialLength);

                                ViggianiBarrett_DFPFActivity_ContactPhase_Interpolated( 1 : MaxContactPhaseLength_AllParticipants ) = interp1( TimeVector_ContactPhase_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFActivity_ContactPhase( 1:LengthofContactPhase_AllHops(o), o ),  TimeVector_ContactPhase_DesiredTrialLength);

                                ViggianiBarrett_DFPFCoactivation_ContactPhase_Interpolated( 1 : MaxContactPhaseLength_AllParticipants ) = interp1( TimeVector_ContactPhase_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCoactivation_ContactPhase( 1:LengthofContactPhase_AllHops(o), o ),  TimeVector_ContactPhase_DesiredTrialLength);


                                
                                 %Interpolate DF-PF Coactivation Data for Absorption Phase                               
                                ViggianiBarrett_DFPFCommonality_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCommonality_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_DFPFActivity_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFActivity_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_DFPFCoactivation_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCoactivation_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                
                                
                                %Interpolate DF-PF Coactivation Data for Generation Phase
                                ViggianiBarrett_DFPFCommonality_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCommonality_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_DFPFActivity_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFActivity_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_DFPFCoactivation_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_DFPFCoactivation_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);
                                
                                
    
                                
                                
                                %Interpolate TS Coactivation Data for Absorption Phase                                
                                ViggianiBarrett_TSCommonality_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_TSCommonality_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_TSActivity_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_TSActivity_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_TSCoactivation_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_TSCoactivation_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                
                                %Interpolate TS Coactivation Data for Generation Phase     
                                ViggianiBarrett_TSCommonality_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_TSCommonality_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_TSActivity_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_TSActivity_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_TSCoactivation_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_TSCoactivation_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);                                
                                
                                
                                



                                %Interpolate Two Joint TS Coactivation Data for Absorption Phase     
                               ViggianiBarrett_2JntTSCommonality_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_2JntTSCommonality_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_2JntTSActivity_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_2JntTSActivity_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_2JntTSCoactivation_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_2JntTSCoactivation_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);


                                
                                 %Interpolate Two Joint TS Coactivation Data for Generation Phase                                  
                                ViggianiBarrett_2JntTSCommonality_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_2JntTSCommonality_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_2JntTSActivity_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_2JntTSActivity_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_2JntTSCoactivation_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_2JntTSCoactivation_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);                                
                                
                                
                                
                                
                                
                                
                                %Interpolate One Joint TS Coactivation Data for Absorption Phase     
                               ViggianiBarrett_1JntTSCommonality_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_1JntTSCommonality_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_1JntTSActivity_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_1JntTSActivity_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);

                                ViggianiBarrett_1JntTSCoactivation_Braking_Interpolated( 1 : MaxBrakingPhaseLength_AllParticipants ) = interp1( TimeVector_Braking_CurrentTrialLength,...
                                    ViggianiBarrett_1JntTSCoactivation_BrakingPhase( 1:LengthofBrakingPhase_AllHops(o), o ),  TimeVector_Braking_DesiredTrialLength);


                                
                                 %Interpolate One Joint TS Coactivation Data for Generation Phase                                  
                                ViggianiBarrett_1JntTSCommonality_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_1JntTSCommonality_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_1JntTSActivity_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_1JntTSActivity_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);

                                ViggianiBarrett_1JntTSCoactivation_Propulsion_Interpolated( 1 : MaxPropulsionPhaseLength_AllParticipants ) = interp1( TimeVector_Propulsion_CurrentTrialLength,...
                                    ViggianiBarrett_1JntTSCoactivation_PropulsionPhase( 1:LengthofPropulsionPhase_AllHops(o), o ),  TimeVector_Propulsion_DesiredTrialLength);                                        
                                
                                
                                
                                
                                
                                
                                


                                GroupIDVector_EntireHopCycle = repmat( k, MaxHopCycleLength_AllParticipants, 1 );
                                ParticipantIDVector_EntireHopCycle = repmat( l, MaxHopCycleLength_AllParticipants, 1 );
                                LimbIDVector_EntireHopCycle = repmat( a, MaxHopCycleLength_AllParticipants, 1 );
                                TrialIDVector_EntireHopCycle = repmat( n, MaxHopCycleLength_AllParticipants, 1 );
                                HopIDVector_EntireHopCycle = repmat( o, MaxHopCycleLength_AllParticipants, 1 );
                                HopRateVector_EntireHopCycle = repmat( HoppingRate_ID_forTble(b), MaxHopCycleLength_AllParticipants, 1 );


                                GroupIDVector_FlightPhase = repmat( k, MaxFlightPhaseLength_AllParticipants, 1 );
                                ParticipantIDVector_FlightPhase = repmat( l, MaxFlightPhaseLength_AllParticipants, 1 );
                                LimbIDVector_FlightPhase = repmat( a, MaxFlightPhaseLength_AllParticipants, 1 );
                                TrialIDVector_FlightPhase = repmat( n, MaxFlightPhaseLength_AllParticipants, 1 );
                                HopIDVector_FlightPhase = repmat( o, MaxFlightPhaseLength_AllParticipants, 1 );
                                HopRateVector_FlightPhase = repmat( HoppingRate_ID_forTble(b), MaxFlightPhaseLength_AllParticipants, 1 );

                                
                                GroupIDVector_ContactPhase = repmat( k, MaxContactPhaseLength_AllParticipants, 1 );
                                ParticipantIDVector_ContactPhase = repmat( l, MaxContactPhaseLength_AllParticipants, 1 );
                                LimbIDVector_ContactPhase = repmat( a, MaxContactPhaseLength_AllParticipants, 1 );
                                TrialIDVector_ContactPhase = repmat( n, MaxContactPhaseLength_AllParticipants, 1 );
                                HopIDVector_ContactPhase = repmat( o, MaxContactPhaseLength_AllParticipants, 1 );
                                HopRateVector_ContactPhase = repmat( HoppingRate_ID_forTble(b), MaxContactPhaseLength_AllParticipants, 1 );
                                
                                
                                
                                GroupIDVector_Braking = repmat( k, MaxBrakingPhaseLength_AllParticipants, 1 );
                                ParticipantIDVector_Braking = repmat( l, MaxBrakingPhaseLength_AllParticipants, 1 );
                                LimbIDVector_Braking = repmat( a, MaxBrakingPhaseLength_AllParticipants, 1 );
                                TrialIDVector_Braking = repmat( n, MaxBrakingPhaseLength_AllParticipants, 1 );
                                HopIDVector_Braking = repmat( o, MaxBrakingPhaseLength_AllParticipants, 1 );
                                HopRateVector_Braking = repmat( HoppingRate_ID_forTble(b), MaxBrakingPhaseLength_AllParticipants, 1 );
                                
                                
                                GroupIDVector_Propulsion = repmat( k, MaxPropulsionPhaseLength_AllParticipants, 1 );
                                ParticipantIDVector_Propulsion = repmat( l, MaxPropulsionPhaseLength_AllParticipants, 1 );
                                LimbIDVector_Propulsion = repmat( a, MaxPropulsionPhaseLength_AllParticipants, 1 );
                                TrialIDVector_Propulsion = repmat( n, MaxPropulsionPhaseLength_AllParticipants, 1 );
                                HopIDVector_Propulsion = repmat( o, MaxPropulsionPhaseLength_AllParticipants, 1 );
                                HopRateVector_Propulsion = repmat( HoppingRate_ID_forTble(b), MaxPropulsionPhaseLength_AllParticipants, 1 );                                

                                

                                
                                

                                
                                %If Portion of Statement - if we're processing the first hop, first trial, first
                                %MTU, and first limb of the first participant, need to create the
                                %matrices in general. Will add in coactivation data and factor
                                %variables (Group_ID, Participant_ID, etc) as new columns.
                                
                                %Else Portion of Statement - if we've already created the matrices in
                                %general, just need to add the new data as new rows.
                                if k == 1 && l == 1 &&  n == 1 && o == 1
                                    
                                    %Create Matrix Containing All PF Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)
                                    
                                        %Entire Hop Cycle
                                    ViggianiBarrett_Coactivation_EntireHopCycle_forR = [GroupIDVector_EntireHopCycle, ParticipantIDVector_EntireHopCycle, LimbIDVector_EntireHopCycle , TrialIDVector_EntireHopCycle, HopIDVector_EntireHopCycle,...
                                        HopRateVector_EntireHopCycle, (1:numel(TimeVector_EntireHopCycle_DesiredTrialLength))', ViggianiBarrett_PFCommonality_EntireHopCycle_Interpolated', ViggianiBarrett_PFActivity_EntireHopCycle_Interpolated', ViggianiBarrett_PFCoactivation_EntireHopCycle_Interpolated'];
                                        %Flight Phase Only
                                    ViggianiBarrett_Coactivation_FlightPhase_forR = [ GroupIDVector_FlightPhase, ParticipantIDVector_FlightPhase, LimbIDVector_FlightPhase , TrialIDVector_FlightPhase, HopIDVector_FlightPhase,...
                                        HopRateVector_FlightPhase, (1:numel(TimeVector_FlightPhase_DesiredTrialLength))', ViggianiBarrett_PFCommonality_FlightPhase_Interpolated', ViggianiBarrett_PFActivity_FlightPhase_Interpolated', ViggianiBarrett_PFCoactivation_FlightPhase_Interpolated'];
                                        %Entire Contact Phase Only
                                    ViggianiBarrett_Coactivation_ContactPhase_forR = [ GroupIDVector_ContactPhase, ParticipantIDVector_ContactPhase, LimbIDVector_ContactPhase , TrialIDVector_ContactPhase, HopIDVector_ContactPhase,...
                                        HopRateVector_ContactPhase, (1:numel(TimeVector_ContactPhase_DesiredTrialLength))', ViggianiBarrett_PFCommonality_ContactPhase_Interpolated', ViggianiBarrett_PFActivity_ContactPhase_Interpolated', ViggianiBarrett_PFCoactivation_ContactPhase_Interpolated'];
                                        %Absorption Phase Only
                                    ViggianiBarrett_Coactivation_Braking_forR = [ GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking , TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_PFCommonality_Braking_Interpolated', ViggianiBarrett_PFActivity_Braking_Interpolated', ViggianiBarrett_PFCoactivation_Braking_Interpolated'];
                                          %Generation Phase Only                                          
                                    ViggianiBarrett_Coactivation_Propulsion_forR = [ GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion , TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_PFCommonality_Propulsion_Interpolated', ViggianiBarrett_PFActivity_Propulsion_Interpolated', ViggianiBarrett_PFCoactivation_Propulsion_Interpolated'];




                                    
                                    %Create Matrix Containing DF-PF Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                       
                                    
                                        %Entire Hop Cycle                                    
                                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR = [GroupIDVector_EntireHopCycle, ParticipantIDVector_EntireHopCycle, LimbIDVector_EntireHopCycle , TrialIDVector_EntireHopCycle, HopIDVector_EntireHopCycle,...
                                        HopRateVector_EntireHopCycle, (1:numel(TimeVector_EntireHopCycle_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_EntireHopCycle_Interpolated', ViggianiBarrett_DFPFActivity_EntireHopCycle_Interpolated', ViggianiBarrett_DFPFCoactivation_EntireHopCycle_Interpolated'];
                                        %Flight Phase Only
                                    ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR = [ GroupIDVector_FlightPhase, ParticipantIDVector_FlightPhase, LimbIDVector_FlightPhase , TrialIDVector_FlightPhase, HopIDVector_FlightPhase,...
                                        HopRateVector_FlightPhase, (1:numel(TimeVector_FlightPhase_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_FlightPhase_Interpolated', ViggianiBarrett_DFPFActivity_FlightPhase_Interpolated', ViggianiBarrett_DFPFCoactivation_FlightPhase_Interpolated'];
                                        %Entire Contact Phase Only
                                    ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR = [ GroupIDVector_ContactPhase, ParticipantIDVector_ContactPhase, LimbIDVector_ContactPhase , TrialIDVector_ContactPhase, HopIDVector_ContactPhase,...
                                        HopRateVector_ContactPhase, (1:numel(TimeVector_ContactPhase_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_ContactPhase_Interpolated', ViggianiBarrett_DFPFActivity_ContactPhase_Interpolated', ViggianiBarrett_DFPFCoactivation_ContactPhase_Interpolated'];
                                        %Absorption Phase Only
                                    ViggianiBarrett_DFPF_Coactivation_Braking_forR = [ GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking , TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_Braking_Interpolated', ViggianiBarrett_DFPFActivity_Braking_Interpolated', ViggianiBarrett_DFPFCoactivation_Braking_Interpolated'];
                                        %Generation Phase Only                                            
                                     ViggianiBarrett_DFPF_Coactivation_Propulsion_forR = [ GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion , TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_Propulsion_Interpolated', ViggianiBarrett_DFPFActivity_Propulsion_Interpolated', ViggianiBarrett_DFPFCoactivation_Propulsion_Interpolated'];
                                    
                                    
                                    
                                    
                                    %Create Matrix Containing TS Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                     
                                    
                                        %Absorption Phase Only                                    
                                    ViggianiBarrett_TS_Coactivation_Braking_forR = [ GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking , TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_TSCommonality_Braking_Interpolated', ViggianiBarrett_TSActivity_Braking_Interpolated', ViggianiBarrett_TSCoactivation_Braking_Interpolated'];
                                        %Generation Phase Only                                            
                                     ViggianiBarrett_TS_Coactivation_Propulsion_forR = [ GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion , TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_TSCommonality_Propulsion_Interpolated', ViggianiBarrett_TSActivity_Propulsion_Interpolated', ViggianiBarrett_TSCoactivation_Propulsion_Interpolated'];
                                                                        
                                    
 
                                    %Create Matrix Containing Two-Joint TS Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)
                                    
                                         %Absorption Phase Only                                   
                                     ViggianiBarrett_2JntTS_Coactivation_Braking_forR = [ GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking , TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_2JntTSCommonality_Braking_Interpolated', ViggianiBarrett_2JntTSActivity_Braking_Interpolated', ViggianiBarrett_2JntTSCoactivation_Braking_Interpolated'];
                                        %Generation Phase Only                                            
                                     ViggianiBarrett_2JntTS_Coactivation_Propulsion_forR = [ GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion , TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_2JntTSCommonality_Propulsion_Interpolated', ViggianiBarrett_2JntTSActivity_Propulsion_Interpolated', ViggianiBarrett_2JntTSCoactivation_Propulsion_Interpolated'];
                                    
                                    
                                    
                                    %Create Matrix Containing One-Joint TS Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                                    
                                    
                                        %Absorption Phase Only                                    
                                     ViggianiBarrett_1JntTS_Coactivation_Braking_forR = [ GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking , TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_1JntTSCommonality_Braking_Interpolated', ViggianiBarrett_1JntTSActivity_Braking_Interpolated', ViggianiBarrett_1JntTSCoactivation_Braking_Interpolated'];
                                        %Generation Phase Only                                    
                                     ViggianiBarrett_1JntTS_Coactivation_Propulsion_forR = [ GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion , TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_1JntTSCommonality_Propulsion_Interpolated', ViggianiBarrett_1JntTSActivity_Propulsion_Interpolated', ViggianiBarrett_1JntTSCoactivation_Propulsion_Interpolated'];
                                    
                                    
                                    
                                else
                                    
                                    
                                     %Add new data to matrix Containing All PF Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)
                                    
                                        %Entire Hop Cycle
                                    ViggianiBarrett_Coactivation_EntireHopCycle_forR = [ ViggianiBarrett_Coactivation_EntireHopCycle_forR; GroupIDVector_EntireHopCycle, ParticipantIDVector_EntireHopCycle, LimbIDVector_EntireHopCycle ,  TrialIDVector_EntireHopCycle, HopIDVector_EntireHopCycle,...
                                        HopRateVector_EntireHopCycle, (1:numel(TimeVector_EntireHopCycle_DesiredTrialLength))', ViggianiBarrett_PFCommonality_EntireHopCycle_Interpolated', ViggianiBarrett_PFActivity_EntireHopCycle_Interpolated', ViggianiBarrett_PFCoactivation_EntireHopCycle_Interpolated'];
                                        %Flight Phase Only
                                    ViggianiBarrett_Coactivation_FlightPhase_forR = [ ViggianiBarrett_Coactivation_FlightPhase_forR; GroupIDVector_FlightPhase, ParticipantIDVector_FlightPhase, LimbIDVector_FlightPhase , TrialIDVector_FlightPhase, HopIDVector_FlightPhase,...
                                        HopRateVector_FlightPhase, (1:numel(TimeVector_FlightPhase_DesiredTrialLength))', ViggianiBarrett_PFCommonality_FlightPhase_Interpolated', ViggianiBarrett_PFActivity_FlightPhase_Interpolated', ViggianiBarrett_PFCoactivation_FlightPhase_Interpolated'];
                                        %Entire Contact Phase Only
                                    ViggianiBarrett_Coactivation_ContactPhase_forR = [ ViggianiBarrett_Coactivation_ContactPhase_forR; GroupIDVector_ContactPhase, ParticipantIDVector_ContactPhase, LimbIDVector_ContactPhase ,  TrialIDVector_ContactPhase, HopIDVector_ContactPhase,...
                                        HopRateVector_ContactPhase, (1:numel(TimeVector_ContactPhase_DesiredTrialLength))', ViggianiBarrett_PFCommonality_ContactPhase_Interpolated', ViggianiBarrett_PFActivity_ContactPhase_Interpolated', ViggianiBarrett_PFCoactivation_ContactPhase_Interpolated'];
                                         %Absorption Phase Only 
                                    ViggianiBarrett_Coactivation_Braking_forR = [ ViggianiBarrett_Coactivation_Braking_forR; GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking ,  TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_PFCommonality_Braking_Interpolated', ViggianiBarrett_PFActivity_Braking_Interpolated', ViggianiBarrett_PFCoactivation_Braking_Interpolated'];
                                         %Generation Phase Only                                          
                                    ViggianiBarrett_Coactivation_Propulsion_forR = [ ViggianiBarrett_Coactivation_Propulsion_forR; GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion ,  TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_PFCommonality_Propulsion_Interpolated', ViggianiBarrett_PFActivity_Propulsion_Interpolated', ViggianiBarrett_PFCoactivation_Propulsion_Interpolated'];
                                    
                                    
                                    
                                    
                                    
                                     %Add new data to matrix Containing DF-PF Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                                    

                                        %Entire Hop Cycle
                                    ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR = [ ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR; GroupIDVector_EntireHopCycle, ParticipantIDVector_EntireHopCycle, LimbIDVector_EntireHopCycle ,  TrialIDVector_EntireHopCycle, HopIDVector_EntireHopCycle,...
                                        HopRateVector_EntireHopCycle, (1:numel(TimeVector_EntireHopCycle_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_EntireHopCycle_Interpolated', ViggianiBarrett_DFPFActivity_EntireHopCycle_Interpolated', ViggianiBarrett_DFPFCoactivation_EntireHopCycle_Interpolated'];
                                        %Flight Phase Only
                                    ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR = [ ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR; GroupIDVector_FlightPhase, ParticipantIDVector_FlightPhase, LimbIDVector_FlightPhase , TrialIDVector_FlightPhase, HopIDVector_FlightPhase,...
                                        HopRateVector_FlightPhase, (1:numel(TimeVector_FlightPhase_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_FlightPhase_Interpolated', ViggianiBarrett_DFPFActivity_FlightPhase_Interpolated', ViggianiBarrett_DFPFCoactivation_FlightPhase_Interpolated'];
                                        %Entire Contact Phase Only
                                    ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR = [ ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR; GroupIDVector_ContactPhase, ParticipantIDVector_ContactPhase, LimbIDVector_ContactPhase ,  TrialIDVector_ContactPhase, HopIDVector_ContactPhase,...
                                        HopRateVector_ContactPhase, (1:numel(TimeVector_ContactPhase_DesiredTrialLength))', ViggianiBarrett_DFPFCommonality_ContactPhase_Interpolated', ViggianiBarrett_DFPFActivity_ContactPhase_Interpolated', ViggianiBarrett_DFPFCoactivation_ContactPhase_Interpolated'];
                                         %Absorption Phase Only 
                                    ViggianiBarrett_DFPF_Coactivation_Braking_forR = [ ViggianiBarrett_DFPF_Coactivation_Braking_forR; GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking ,  TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, [1:numel(TimeVector_Braking_DesiredTrialLength)]', ViggianiBarrett_DFPFCommonality_Braking_Interpolated', ViggianiBarrett_DFPFActivity_Braking_Interpolated', ViggianiBarrett_DFPFCoactivation_Braking_Interpolated'];
                                        %Generation Phase Only                                           
                                    ViggianiBarrett_DFPF_Coactivation_Propulsion_forR = [ ViggianiBarrett_DFPF_Coactivation_Propulsion_forR; GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion ,  TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, [1:numel(TimeVector_Propulsion_DesiredTrialLength)]', ViggianiBarrett_DFPFCommonality_Propulsion_Interpolated', ViggianiBarrett_DFPFActivity_Propulsion_Interpolated', ViggianiBarrett_DFPFCoactivation_Propulsion_Interpolated'];

                                    
                                    
                                      %Add new data to matrix Containing All TS Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                                   
 
                                         %Absorption Phase Only                                     
                                    ViggianiBarrett_TS_Coactivation_Braking_forR = [ ViggianiBarrett_TS_Coactivation_Braking_forR; GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking ,  TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, [1:numel(TimeVector_Braking_DesiredTrialLength)]', ViggianiBarrett_TSCommonality_Braking_Interpolated', ViggianiBarrett_TSActivity_Braking_Interpolated', ViggianiBarrett_TSCoactivation_Braking_Interpolated'];
                                        %Generation Phase Only                                           
                                    ViggianiBarrett_TS_Coactivation_Propulsion_forR = [ ViggianiBarrett_TS_Coactivation_Propulsion_forR; GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion ,  TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, [1:numel(TimeVector_Propulsion_DesiredTrialLength)]', ViggianiBarrett_TSCommonality_Propulsion_Interpolated', ViggianiBarrett_TSActivity_Propulsion_Interpolated', ViggianiBarrett_TSCoactivation_Propulsion_Interpolated'];                                    
                                    
                                    
                                    
                                        %Add new data to matrix Containing All TS Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                                   
 
                                          %Absorption Phase Only                                    
                                    ViggianiBarrett_2JntTS_Coactivation_Braking_forR = [ ViggianiBarrett_2JntTS_Coactivation_Braking_forR; GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking ,  TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, [1:numel(TimeVector_Braking_DesiredTrialLength)]', ViggianiBarrett_2JntTSCommonality_Braking_Interpolated', ViggianiBarrett_2JntTSActivity_Braking_Interpolated', ViggianiBarrett_2JntTSCoactivation_Braking_Interpolated'];
                                          %Generation Phase Only                                         
                                    ViggianiBarrett_2JntTS_Coactivation_Propulsion_forR = [ ViggianiBarrett_2JntTS_Coactivation_Propulsion_forR; GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion ,  TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, [1:numel(TimeVector_Propulsion_DesiredTrialLength)]', ViggianiBarrett_2JntTSCommonality_Propulsion_Interpolated', ViggianiBarrett_2JntTSActivity_Propulsion_Interpolated', ViggianiBarrett_2JntTSCoactivation_Propulsion_Interpolated'];                                    
                                                      
                                    
                                    
                                      %Add new data to matrix Containing All One Joint Coactivation Data and
                                    %Factors (Group_ID, Participant_ID, etc)                                   
                                    
                                         %Absorption Phase Only                                     
                                    ViggianiBarrett_1JntTS_Coactivation_Braking_forR = [ ViggianiBarrett_1JntTS_Coactivation_Braking_forR; GroupIDVector_Braking, ParticipantIDVector_Braking, LimbIDVector_Braking ,  TrialIDVector_Braking, HopIDVector_Braking,...
                                        HopRateVector_Braking, (1:numel(TimeVector_Braking_DesiredTrialLength))', ViggianiBarrett_1JntTSCommonality_Braking_Interpolated', ViggianiBarrett_1JntTSActivity_Braking_Interpolated', ViggianiBarrett_1JntTSCoactivation_Braking_Interpolated'];
                                          %Generation Phase Only                                         
                                    ViggianiBarrett_1JntTS_Coactivation_Propulsion_forR = [ ViggianiBarrett_1JntTS_Coactivation_Propulsion_forR; GroupIDVector_Propulsion, ParticipantIDVector_Propulsion, LimbIDVector_Propulsion ,  TrialIDVector_Propulsion, HopIDVector_Propulsion,...
                                        HopRateVector_Propulsion, (1:numel(TimeVector_Propulsion_DesiredTrialLength))', ViggianiBarrett_1JntTSCommonality_Propulsion_Interpolated', ViggianiBarrett_1JntTSActivity_Propulsion_Interpolated', ViggianiBarrett_1JntTSCoactivation_Propulsion_Interpolated'];                                    
                                                                        
                                    
                                    
                                end


                                
                                
        %% End O For Loop                    
                            end %End o for loop

%                         EntireHopCycle_IndicesforOneTrial = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 5 ) == n );
% 
%                         %% Segment Out Data for One Hopping BOUT - Entire Hop Cycle
% 
%                         EntireHopCycle_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_Coactivation_EntireHopCycle_forR( EntireHopCycle_IndicesforOneGroup, : );
% 
% 
%                         EntireHopCycle_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_IndicesforOneParticipant, : );
% 
% 
% 
%                         EntireHopCycle_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_IndicesforOneLimb, : );
% 
% 
% 
%                         EntireHopCycle_IndicesforOneMTU = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( :, 4 ) == m );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_OneMTU = ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_IndicesforOneMTU, : );
%                         
%                         
%                         
%                         EntireHopCycle_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneMTU( :, 7 ) == b );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_OneRate = ViggianiBarrett_Coactivation_EntireHopCycle_OneMTU( EntireHopCycle_IndicesforOneHoppingRate, : );
%                         
%                         
% 
% 
%                         EntireHopCycle_IndicesforOneBout = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneRate( :, 5 ) == n );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_OneBout = ViggianiBarrett_Coactivation_EntireHopCycle_OneRate ( EntireHopCycle_IndicesforOneBout, : );
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%                         EntireHopCycle_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( EntireHopCycle_DFPF_IndicesforOneGroup, : );
% 
% 
%                         EntireHopCycle_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_DFPF_IndicesforOneParticipant, : );
% 
% 
% 
%                         EntireHopCycle_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_DFPF_IndicesforOneLimb, : );
% 
% 
% 
%                         EntireHopCycle_DFPF_IndicesforOneMTU = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( :, 4 ) == m );
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneMTU = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_DFPF_IndicesforOneMTU, : );
% 
% 
%                         
%                         
%                         EntireHopCycle_DFPF_IndicesforOneHoppingRate = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneMTU( :, 7 ) == b );
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneRate = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneMTU( EntireHopCycle_DFPF_IndicesforOneHoppingRate, : );
%                         
%                         
% 
% 
%                         EntireHopCycle_DFPF_IndicesforOneBout = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneRate( :, 5 ) == n );
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneBout = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneRate ( EntireHopCycle_DFPF_IndicesforOneBout, : );
% 
% 
% 
%         %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Bout - Entire Hop Cycle
% 
%                         for s = 1 : MaxHopCycleLength_AllParticipants
% 
%                             EntireHopCycle_OneDataPoint = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneBout(:, 7) ==  s );
% 
%                             ViggianiBarrett_Coactivation_EntireHopCycle_BoutMeans( RowtoFill_OnePerBout , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_EntireHopCycle_OneBout( EntireHopCycle_OneDataPoint, :), 1 );
% 
% 
% 
%                             ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_BoutMeans( RowtoFill_OnePerBout , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneBout( EntireHopCycle_OneDataPoint, :), 1 );
% 
%                             RowtoFill_OnePerBout = RowtoFill_OnePerBout + 1;
% 
%                         end
% 
% 
%                         
%                         
%         %% Segment Out Data for One Hopping Bout - Flight Phase
% 
%                         FlightPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_FlightPhase_forR( :, 1 ) == k );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_Coactivation_FlightPhase_forR( FlightPhase_IndicesforOneGroup, : );
% 
% 
%                         FlightPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_IndicesforOneParticipant, : );
% 
% 
% 
%                         FlightPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( FlightPhase_IndicesforOneLimb, : );
% 
% 
% 
%                         FlightPhase_IndicesforOneMTU = find( ViggianiBarrett_Coactivation_FlightPhase_OneLimb( :, 4 ) == m );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_OneMTU = ViggianiBarrett_Coactivation_FlightPhase_OneLimb( FlightPhase_IndicesforOneMTU, : );
% 
% 
%                         
%                         
%                          FlightPhase_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_FlightPhase_OneMTU( :, 7 ) == b );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_OneRate = ViggianiBarrett_Coactivation_FlightPhase_OneMTU(  FlightPhase_IndicesforOneHoppingRate, : );
%                         
%                         
% 
% 
%                          FlightPhase_IndicesforOneBout = find( ViggianiBarrett_Coactivation_FlightPhase_OneRate( :, 5 ) == n );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_OneBout = ViggianiBarrett_Coactivation_FlightPhase_OneRate (  FlightPhase_IndicesforOneBout, : );
% 
% 
% 
% 
% 
% 
% 
% 
%                         FlightPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( :, 1 ) == k );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( FlightPhase_DFPF_IndicesforOneGroup, : );
% 
% 
%                         FlightPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_DFPF_IndicesforOneParticipant, : );
% 
% 
% 
%                         FlightPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( FlightPhase_DFPF_IndicesforOneLimb, : );
% 
% 
% 
%                         FlightPhase_DFPF_IndicesforOneMTU = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb( :, 4 ) == m );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneMTU = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb( FlightPhase_DFPF_IndicesforOneMTU, : );
% 
% 
%                         FlightPhase_DFPF_IndicesforOneRate = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneMTU( :, 7 ) == b );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneRate = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneMTU( FlightPhase_DFPF_IndicesforOneRate, : );
% 
% 
%                          FlightPhase_DFPF_IndicesforOneBout = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneRate( :, 5 ) == n );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneBout = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneRate (  FlightPhase_DFPF_IndicesforOneBout, : );
% 
% 
%         %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Bout - Flight Phase
% 
%                         for s = 1 : MaxFlightPhaseLength_AllParticipants
% 
%                             FlightPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_FlightPhase_OneBout(:, 7) ==  s );
% 
%                             ViggianiBarrett_Coactivation_FlightPhase_BoutMeans( RowtoFill_OnePerBout_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_FlightPhase_OneBout( FlightPhase_OneDataPoint, :), 1 );
% 
% 
% 
%                             ViggianiBarrett_DFPF_Coactivation_FlightPhase_BoutMeans( RowtoFill_OnePerBout_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneBout( FlightPhase_OneDataPoint, :), 1 );
% 
%                             RowtoFill_OnePerBout_FlightPhase = RowtoFill_OnePerBout_FlightPhase + 1;
% 
%                         end
% 
% 
% 
%         %% Segment Out Data for One Hopping Bout - Contact Phase
% 
%                         ContactPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_ContactPhase_forR( :, 1 ) == k );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_Coactivation_ContactPhase_forR( ContactPhase_IndicesforOneGroup, : );
% 
% 
%                         ContactPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_IndicesforOneParticipant, : );
% 
% 
%                         ContactPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( ContactPhase_IndicesforOneLimb, : );
% 
% 
% 
%                         ContactPhase_IndicesforOneMTU = find( ViggianiBarrett_Coactivation_ContactPhase_OneLimb( :, 4 ) == m );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_OneMTU = ViggianiBarrett_Coactivation_ContactPhase_OneLimb( ContactPhase_IndicesforOneMTU, : );
% 
% 
%                          ContactPhase_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_ContactPhase_OneMTU( :, 7 ) == b );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_OneRate = ViggianiBarrett_Coactivation_ContactPhase_OneMTU(  ContactPhase_IndicesforOneHoppingRate, : );
%                         
% 
% 
%                          ContactPhase_IndicesforOneBout = find( ViggianiBarrett_Coactivation_ContactPhase_OneRate( :, 5 ) == n );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_OneBout = ViggianiBarrett_Coactivation_ContactPhase_OneRate (  ContactPhase_IndicesforOneBout, : );
% 
% 
% 
% 
% 
% 
% 
% 
%                         ContactPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( :, 1 ) == k );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( ContactPhase_DFPF_IndicesforOneGroup, : );
% 
% 
%                         ContactPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_DFPF_IndicesforOneParticipant, : );
% 
% 
%                         ContactPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( ContactPhase_DFPF_IndicesforOneLimb, : );
% 
% 
% 
%                         ContactPhase_DFPF_IndicesforOneMTU = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb( :, 4 ) == m );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneMTU = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb( ContactPhase_DFPF_IndicesforOneMTU, : );
% 
% 
%                         ContactPhase_DFPF_IndicesforOneRate = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneMTU( :, 7 ) == b );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneRate = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneMTU( ContactPhase_DFPF_IndicesforOneRate, : );
% 
% 
%                          ContactPhase_DFPF_IndicesforOneBout = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneRate( :, 5 ) == n );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneBout = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneRate (  ContactPhase_DFPF_IndicesforOneBout, : );
% 
% 
%         %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Bout - Contact Phase
% 
%                         for s = 1 : MaxContactPhaseLength_AllParticipants
% 
%                             ContactPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_ContactPhase_OneBout(:, 7) ==  s );
% 
%                             ViggianiBarrett_Coactivation_ContactPhase_BoutMeans( RowtoFill_OnePerBout_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_ContactPhase_OneBout( ContactPhase_OneDataPoint, :), 1 );
% 
% 
% 
%                             ViggianiBarrett_DFPF_Coactivation_ContactPhase_BoutMeans( RowtoFill_OnePerBout_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneBout( ContactPhase_OneDataPoint, :), 1 );
% 
%                             RowtoFill_OnePerBout_ContactPhase = RowtoFill_OnePerBout_ContactPhase + 1;
% 
%                         end              
% 
% 
% 
%                          %% Create and Write Tbles With Data Averaged For Each Trial
% 
%                          VariableNames = { ' Group_ID ', ' Participant_ID ', 'Limb_ID' ,' MTU_ID ', ' Trial_ID ', ' Hop_ID ', 'HoppingRate_ID' ,' Data_Point ' , ' Commonality ', ' Activity ', ' Coactivation ' };
% 
% 
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_BoutMeans_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_BoutMeans, 'VariableNames', VariableNames );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_BoutMeans_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_BoutMeans, 'VariableNames', VariableNames );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_BoutMeans_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_BoutMeans, 'VariableNames', VariableNames );
% 
% 
% 
%                         writetable(ViggianiBarrett_Coactivation_EntireHopCycle_BoutMeans_Tble, ['ViggianiBarrett_Coactivation_EntireHopCycle_BoutMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,HoppingTrialNumber{n}, '.xlsx' ] );
% 
%                         writetable(ViggianiBarrett_Coactivation_FlightPhase_BoutMeans_Tble, ['ViggianiBarrett_Coactivation_FlightPhase_BoutMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  HoppingTrialNumber{n}  ,'.xlsx' ] );
% 
%                         writetable(ViggianiBarrett_Coactivation_ContactPhase_BoutMeans_Tble, ['ViggianiBarrett_Coactivation_ContactPhase_BoutMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  HoppingTrialNumber{n}  ,'.xlsx' ] );
% 
% 
% 
% 
% 
% 
% 
% 
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_BoutMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_BoutMeans, 'VariableNames', VariableNames );
% 
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_BoutMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_FlightPhase_BoutMeans, 'VariableNames', VariableNames );
% 
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_BoutMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_ContactPhase_BoutMeans, 'VariableNames', VariableNames );
% 
% 
% 
%                         writetable(ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_BoutMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_BoutMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  , HoppingTrialNumber{n}, '.xlsx' ] );
% 
%                         writetable(ViggianiBarrett_DFPF_Coactivation_FlightPhase_BoutMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_FlightPhase_BoutMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  HoppingTrialNumber{n}  ,'.xlsx' ] );
% 
%                         writetable(ViggianiBarrett_DFPF_Coactivation_ContactPhase_BoutMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_ContactPhase_BoutMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  HoppingTrialNumber{n}  ,'.xlsx' ] );

                        
    %% END N For Loop - for HoppingTrialNumber

                        end %End n for loop

                  
                        
 
                        %% Segment Out Data for One Hopping RATE - Entire Hop Cycle
                        
                        
%Col 1 = Group, Col 2 = Participant, Col 3 = Limb, Col 4 =
                                    %Trial, Col 5 = Hop, Col 6 = Hop Rate, Col 7 = Time, Col 8 =
                                    %Commonality, Col 9 = Activity, Col 10 = Coactivation
                        
                                    
 %Coactivation Between All PF
 
                        %Find all rows corresponding to Group K         
                        EntireHopCycle_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_Coactivation_EntireHopCycle_forR( EntireHopCycle_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        EntireHopCycle_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        EntireHopCycle_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_IndicesforOneLimb, : );

                        
                        
                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        EntireHopCycle_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_Coactivation_EntireHopCycle_OneRate = ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_IndicesforOneHoppingRate, : );





%DF-PF Coactivation                        

                        %Find all rows corresponding to Group K
                        EntireHopCycle_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( EntireHopCycle_DFPF_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        EntireHopCycle_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_DFPF_IndicesforOneParticipant, : );



                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        EntireHopCycle_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_DFPF_IndicesforOneLimb, : );

                        
                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        EntireHopCycle_DFPF_IndicesforOneHoppingRate = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneRate = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_DFPF_IndicesforOneHoppingRate, : );



        %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping RATE - Entire Hop Cycle

                        for s = 1 : MaxHopCycleLength_AllParticipants

                            %Find all rows in matrix that correspond to a single point in time - Entire Hop Cycle                            
                            EntireHopCycle_OneDataPoint = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneRate(:, 7) ==  s );

                            
                            %Average all rows corresponding to said single point in time and add to
                            %matrix containing averages for each point time                      
                            
    %All PF Coactivation
                            ViggianiBarrett_Coactivation_EntireHopCycle_RATEMeans( RowtoFill_OnePerRate , 1 : 10 ) = mean( ViggianiBarrett_Coactivation_EntireHopCycle_OneRate( EntireHopCycle_OneDataPoint, :), 1 );


    %DF-PF Coactivation
                            ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_RATEMeans( RowtoFill_OnePerRate , 1 : 10 ) = mean( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneRate( EntireHopCycle_OneDataPoint, :), 1 );

                            
                            RowtoFill_OnePerRate = RowtoFill_OnePerRate + 1;

                        end


                        
                        
        %% Segment Out Data for One Hopping RATE - Flight Phase

        
 %Coactivation Between All PF
 
                        %Find all rows corresponding to Group K 
                        FlightPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_FlightPhase_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_Coactivation_FlightPhase_forR( FlightPhase_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        FlightPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_IndicesforOneParticipant, : );



                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        FlightPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( FlightPhase_IndicesforOneLimb, : );


                        
                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                         FlightPhase_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_FlightPhase_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                         %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_Coactivation_FlightPhase_OneRate = ViggianiBarrett_Coactivation_FlightPhase_OneLimb(  FlightPhase_IndicesforOneHoppingRate, : );




%DF-PF Coactivation

                        %Find all rows corresponding to Group K 
                        FlightPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( FlightPhase_DFPF_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        FlightPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_DFPF_IndicesforOneParticipant, : );



                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        FlightPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( FlightPhase_DFPF_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        FlightPhase_DFPF_IndicesforOneRate = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneRate = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb( FlightPhase_DFPF_IndicesforOneRate, : );

                        

        %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping RATE - Flight Phase

                        for s = 1 : MaxFlightPhaseLength_AllParticipants

                            %Find all rows in matrix that correspond to a single point in time - Flight Phase                            
                            FlightPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_FlightPhase_OneRate(:, 7) ==  s );

                            %Average all rows corresponding to said single point in time and add to
                            %matrix containing averages for each point time
                            
    %All PF Coactivation                            
                            ViggianiBarrett_Coactivation_FlightPhase_RATEMeans( RowtoFill_OnePerRate_FlightPhase , 1 : 10 ) = mean( ViggianiBarrett_Coactivation_FlightPhase_OneRate( FlightPhase_OneDataPoint, :), 1 );


    %DF-PF Coactivation
                            ViggianiBarrett_DFPF_Coactivation_FlightPhase_RATEMeans( RowtoFill_OnePerRate_FlightPhase , 1 : 10 ) = mean( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneRate( FlightPhase_OneDataPoint, :), 1 );

                            RowtoFill_OnePerRate_FlightPhase = RowtoFill_OnePerRate_FlightPhase + 1;

                        end


                        
                        

        %% Segment Out Data for One Hopping RATE - Contact Phase

        
 %Coactivation Between All PF
 
                        %Find all rows corresponding to Group K 
                        ContactPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_ContactPhase_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_Coactivation_ContactPhase_forR( ContactPhase_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        ContactPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        ContactPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( ContactPhase_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                         ContactPhase_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_ContactPhase_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                         %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_Coactivation_ContactPhase_OneRate = ViggianiBarrett_Coactivation_ContactPhase_OneLimb(  ContactPhase_IndicesforOneHoppingRate, : );






%DF-PF Coactivation

                        %Find all rows corresponding to Group K 
                        ContactPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( ContactPhase_DFPF_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        ContactPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_DFPF_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        ContactPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( ContactPhase_DFPF_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        ContactPhase_DFPF_IndicesforOneRate = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneRate = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb( ContactPhase_DFPF_IndicesforOneRate, : );


                        
        %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping RATE - Contact Phase

                        for s = 1 : MaxContactPhaseLength_AllParticipants

                            
                            %Find all rows in matrix that correspond to a single point in time - Entire Contact Phase                            
                            ContactPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_ContactPhase_OneRate(:, 7) ==  s );

                            %Average all rows corresponding to said single point in time and add to
                            %matrix containing averages for each point time             
                            
    %All PF Coactivation                            
                            ViggianiBarrett_Coactivation_ContactPhase_RATEMeans( RowtoFill_OnePerRate_ContactPhase , 1 : 10 ) = mean( ViggianiBarrett_Coactivation_ContactPhase_OneRate( ContactPhase_OneDataPoint, :), 1 );


    %DF-PF Coactivation
                            ViggianiBarrett_DFPF_Coactivation_ContactPhase_RATEMeans( RowtoFill_OnePerRate_ContactPhase , 1 : 10 ) = mean( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneRate( ContactPhase_OneDataPoint, :), 1 );

                            RowtoFill_OnePerRate_ContactPhase = RowtoFill_OnePerRate_ContactPhase + 1;

                        end              


                        
                        
        %% Segment Out Data for One Hopping RATE - Absorption Phase

        
 %Coactivation Between All PF 
 
                        %Find all rows corresponding to Group K 
                        BrakingPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_Braking_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_Coactivation_Braking_OneGroup = ViggianiBarrett_Coactivation_Braking_forR( BrakingPhase_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        BrakingPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_Braking_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_Coactivation_Braking_OneParticipant = ViggianiBarrett_Coactivation_Braking_OneGroup( BrakingPhase_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        BrakingPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_Braking_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_Coactivation_Braking_OneLimb = ViggianiBarrett_Coactivation_Braking_OneParticipant( BrakingPhase_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                         BrakingPhase_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_Braking_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                         %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_Coactivation_Braking_OneRate = ViggianiBarrett_Coactivation_Braking_OneLimb(  BrakingPhase_IndicesforOneHoppingRate, : );






%DF-PF Coactivation

                        %Find all rows corresponding to Group K 
                        BrakingPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_Braking_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_DFPF_Coactivation_Braking_OneGroup = ViggianiBarrett_DFPF_Coactivation_Braking_forR( BrakingPhase_DFPF_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        BrakingPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_Braking_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_DFPF_Coactivation_Braking_OneParticipant = ViggianiBarrett_DFPF_Coactivation_Braking_OneGroup( BrakingPhase_DFPF_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        BrakingPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_Braking_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_DFPF_Coactivation_Braking_OneLimb = ViggianiBarrett_DFPF_Coactivation_Braking_OneParticipant( BrakingPhase_DFPF_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        BrakingPhase_DFPF_IndicesforOneRate = find( ViggianiBarrett_DFPF_Coactivation_Braking_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_DFPF_Coactivation_Braking_OneRate = ViggianiBarrett_DFPF_Coactivation_Braking_OneLimb( BrakingPhase_DFPF_IndicesforOneRate, : );


                        
                        
                        
                        
                        
%Coactivation Between TS Only                 

                        %Find all rows corresponding to Group K 
                        BrakingPhase_TS_IndicesforOneGroup = find( ViggianiBarrett_TS_Coactivation_Braking_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_TS_Coactivation_Braking_OneGroup = ViggianiBarrett_TS_Coactivation_Braking_forR( BrakingPhase_TS_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        BrakingPhase_TS_IndicesforOneParticipant = find( ViggianiBarrett_TS_Coactivation_Braking_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_TS_Coactivation_Braking_OneParticipant = ViggianiBarrett_TS_Coactivation_Braking_OneGroup( BrakingPhase_TS_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        BrakingPhase_TS_IndicesforOneLimb = find( ViggianiBarrett_TS_Coactivation_Braking_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_TS_Coactivation_Braking_OneLimb = ViggianiBarrett_TS_Coactivation_Braking_OneParticipant( BrakingPhase_TS_IndicesforOneLimb, : );




                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        BrakingPhase_TS_IndicesforOneRate = find( ViggianiBarrett_TS_Coactivation_Braking_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_TS_Coactivation_Braking_OneRate = ViggianiBarrett_TS_Coactivation_Braking_OneLimb( BrakingPhase_TS_IndicesforOneRate, : );                      
                        
                        
  
                        
                        
                        
 %Two Joint TS vs All PF
 
                        %Find all rows corresponding to Group K 
                         BrakingPhase_TwoJointTS_IndicesforOneGroup = find( ViggianiBarrett_2JntTS_Coactivation_Braking_forR( :, 1 ) == k );

                         %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_2JntTS_Coactivation_Braking_OneGroup = ViggianiBarrett_2JntTS_Coactivation_Braking_forR( BrakingPhase_TwoJointTS_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        BrakingPhase_TwoJointTS_IndicesforOneParticipant = find( ViggianiBarrett_2JntTS_Coactivation_Braking_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_2JntTS_Coactivation_Braking_OneParticipant = ViggianiBarrett_2JntTS_Coactivation_Braking_OneGroup( BrakingPhase_TwoJointTS_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        BrakingPhase_TwoJointTS_IndicesforOneLimb = find( ViggianiBarrett_2JntTS_Coactivation_Braking_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_2JntTS_Coactivation_Braking_OneLimb = ViggianiBarrett_2JntTS_Coactivation_Braking_OneParticipant( BrakingPhase_TwoJointTS_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        BrakingPhase_TwoJointTS_IndicesforOneRate = find( ViggianiBarrett_2JntTS_Coactivation_Braking_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_2JntTS_Coactivation_Braking_OneRate = ViggianiBarrett_2JntTS_Coactivation_Braking_OneLimb( BrakingPhase_TwoJointTS_IndicesforOneRate, : );     
                        
                        
                        
                        
                        
%One Joint TS vs All PF

                        %Find all rows corresponding to Group K 
                        BrakingPhase_OneJointTS_IndicesforOneGroup = find( ViggianiBarrett_1JntTS_Coactivation_Braking_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_1JntTS_Coactivation_Braking_OneGroup = ViggianiBarrett_1JntTS_Coactivation_Braking_forR( BrakingPhase_OneJointTS_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        BrakingPhase_OneJointTS_IndicesforOneParticipant = find( ViggianiBarrett_1JntTS_Coactivation_Braking_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_1JntTS_Coactivation_Braking_OneParticipant = ViggianiBarrett_1JntTS_Coactivation_Braking_OneGroup( BrakingPhase_OneJointTS_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        BrakingPhase_OneJointTS_IndicesforOneLimb = find( ViggianiBarrett_1JntTS_Coactivation_Braking_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_1JntTS_Coactivation_Braking_OneLimb = ViggianiBarrett_1JntTS_Coactivation_Braking_OneParticipant( BrakingPhase_OneJointTS_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        BrakingPhase_OneJointTS_IndicesforOneRate = find( ViggianiBarrett_1JntTS_Coactivation_Braking_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_1JntTS_Coactivation_Braking_OneRate = ViggianiBarrett_1JntTS_Coactivation_Braking_OneLimb( BrakingPhase_OneJointTS_IndicesforOneRate, : );     
                        
                        
                        
                        
        %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping RATE - Absorption Phase

                        for s = 1 : MaxBrakingPhaseLength_AllParticipants

                            %Find all rows in matrix that correspond to a single point in time -
                            %Absorption Phase
                            BrakingPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_Braking_OneRate(:, 7) ==  s );

                            %Average all rows corresponding to said single point in time and add to
                            %matrix containing averages for each point time
                            
    %All PF Coactivation                            
                            ViggianiBarrett_Coactivation_Braking_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_Coactivation_Braking_OneRate( BrakingPhase_OneDataPoint, :), 1 );


    %DF-PF Coactivation                            
                           ViggianiBarrett_DFPF_Coactivation_Braking_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_DFPF_Coactivation_Braking_OneRate( BrakingPhase_OneDataPoint, :), 1 );

       
                            
    %Coactivation Between TS Only                            
                           ViggianiBarrett_TS_Coactivation_Braking_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_TS_Coactivation_Braking_OneRate( BrakingPhase_OneDataPoint, :), 1 );

                           
    %Two Joint TS vs All PF Coactivation Data                              
                           ViggianiBarrett_2JntTS_Coactivation_Braking_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_2JntTS_Coactivation_Braking_OneRate( BrakingPhase_OneDataPoint, :), 1 );

    %One Joint TS vs All PF Coactivation Data                           
                           ViggianiBarrett_1JntTS_Coactivation_Braking_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_1JntTS_Coactivation_Braking_OneRate( BrakingPhase_OneDataPoint, :), 1 );
                           
                           
                           
                            RowtoFill_OnePerRate_BrakingPhase = RowtoFill_OnePerRate_BrakingPhase + 1;

                        end                                      
                        
                        
                        

                        
                        
         %% Segment Out Data for One Hopping RATE - Generation Phase

         
 %Coactivation Between All PF 
 
                        %Find all rows corresponding to Group K 
                        PropulsionPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_Propulsion_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_Coactivation_Propulsion_OneGroup = ViggianiBarrett_Coactivation_Propulsion_forR( PropulsionPhase_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        PropulsionPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_Propulsion_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_Coactivation_Propulsion_OneParticipant = ViggianiBarrett_Coactivation_Propulsion_OneGroup( PropulsionPhase_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        PropulsionPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_Propulsion_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_Coactivation_Propulsion_OneLimb = ViggianiBarrett_Coactivation_Propulsion_OneParticipant( PropulsionPhase_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                         PropulsionPhase_IndicesforOneHoppingRate = find( ViggianiBarrett_Coactivation_Propulsion_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                         %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_Coactivation_Propulsion_OneRate = ViggianiBarrett_Coactivation_Propulsion_OneLimb(  PropulsionPhase_IndicesforOneHoppingRate, : );




%DF-PF Coactivation

                        %Find all rows corresponding to Group K 
                        PropulsionPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_Propulsion_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_DFPF_Coactivation_Propulsion_OneGroup = ViggianiBarrett_DFPF_Coactivation_Propulsion_forR( PropulsionPhase_DFPF_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        PropulsionPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_Propulsion_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_DFPF_Coactivation_Propulsion_OneParticipant = ViggianiBarrett_DFPF_Coactivation_Propulsion_OneGroup( PropulsionPhase_DFPF_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        PropulsionPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_Propulsion_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_DFPF_Coactivation_Propulsion_OneLimb = ViggianiBarrett_DFPF_Coactivation_Propulsion_OneParticipant( PropulsionPhase_DFPF_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        PropulsionPhase_DFPF_IndicesforOneRate = find( ViggianiBarrett_DFPF_Coactivation_Propulsion_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_DFPF_Coactivation_Propulsion_OneRate = ViggianiBarrett_DFPF_Coactivation_Propulsion_OneLimb( PropulsionPhase_DFPF_IndicesforOneRate, : );


                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                         %Find all rows corresponding to Group K 
                         PropulsionPhase_TS_IndicesforOneGroup = find( ViggianiBarrett_TS_Coactivation_Propulsion_forR( :, 1 ) == k );

                         %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_TS_Coactivation_Propulsion_OneGroup = ViggianiBarrett_TS_Coactivation_Propulsion_forR( PropulsionPhase_TS_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        PropulsionPhase_TS_IndicesforOneParticipant = find( ViggianiBarrett_TS_Coactivation_Propulsion_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_TS_Coactivation_Propulsion_OneParticipant = ViggianiBarrett_TS_Coactivation_Propulsion_OneGroup( PropulsionPhase_TS_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        PropulsionPhase_TS_IndicesforOneLimb = find( ViggianiBarrett_TS_Coactivation_Propulsion_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_TS_Coactivation_Propulsion_OneLimb = ViggianiBarrett_TS_Coactivation_Propulsion_OneParticipant( PropulsionPhase_TS_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        PropulsionPhase_TS_IndicesforOneRate = find( ViggianiBarrett_TS_Coactivation_Propulsion_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_TS_Coactivation_Propulsion_OneRate = ViggianiBarrett_TS_Coactivation_Propulsion_OneLimb( PropulsionPhase_TS_IndicesforOneRate, : );                       
                        
                        
                        
                        
                        
                        
  %Two Joint TS vs All PF
 
                         %Find all rows corresponding to Group K 
                         PropulsionPhase_TwoJointTS_IndicesforOneGroup = find( ViggianiBarrett_2JntTS_Coactivation_Propulsion_forR( :, 1 ) == k );

                         %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneGroup = ViggianiBarrett_2JntTS_Coactivation_Propulsion_forR( PropulsionPhase_TwoJointTS_IndicesforOneGroup, : );

                        

                        %In the Group K matrix, find all rows corresponding to Participant L
                        PropulsionPhase_TwoJointTS_IndicesforOneParticipant = find( ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneParticipant = ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneGroup( PropulsionPhase_TwoJointTS_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        PropulsionPhase_TwoJointTS_IndicesforOneLimb = find( ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneParticipant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneLimb = ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneParticipant( PropulsionPhase_TwoJointTS_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        PropulsionPhase_TwoJointTS_IndicesforOneRate = find( ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneRate = ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneLimb( PropulsionPhase_TwoJointTS_IndicesforOneRate, : );     
                        
                        
                        
                        
                        
%One Joint TS vs All PF

                        %Find all rows corresponding to Group K 
                        PropulsionPhase_OneJointTS_IndicesforOneGroup = find( ViggianiBarrett_1JntTS_Coactivation_Propulsion_forR( :, 1 ) == k );

                        %Create a new matrix containing only the rows for Group K
                        ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneGroup = ViggianiBarrett_1JntTS_Coactivation_Propulsion_forR( PropulsionPhase_OneJointTS_IndicesforOneGroup, : );


                        %In the Group K matrix, find all rows corresponding to Participant L
                        PropulsionPhase_OneJointTS_IndicesforOneParticipant = find( ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneGroup( :, 2 ) == l );

                        %Create a new matrix containing only the rows for Group K, Participant L
                        ViggianiBarrett_1JntTS_Coactivation_Propulsion_1Participant = ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneGroup( PropulsionPhase_OneJointTS_IndicesforOneParticipant, : );


                        %In the Group K + Participant L matrix, find all rows corresponding to Limb
                        %A
                        PropulsionPhase_OneJointTS_IndicesforOneLimb = find( ViggianiBarrett_1JntTS_Coactivation_Propulsion_1Participant( :, 3 ) == a );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A
                        ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneLimb = ViggianiBarrett_1JntTS_Coactivation_Propulsion_1Participant( PropulsionPhase_OneJointTS_IndicesforOneLimb, : );



                        %In the Group K + Participant L + Limb A matrix, find all rows corresponding
                        %to Hopping Rate B
                        PropulsionPhase_OneJointTS_IndicesforOneRate = find( ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneLimb( :, 6 ) == HoppingRate_ID_forTble(b) );

                        %Create a new matrix containing only the rows for Group K, Participant L,
                        %Limb A, Hopping Rate B
                        ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneRate = ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneLimb( PropulsionPhase_OneJointTS_IndicesforOneRate, : );     
                                               
                        
                        
                        
                        
                        
                        
                        
%% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping RATE - Generation Phase

                        for s = 1 : MaxPropulsionPhaseLength_AllParticipants

                            
                            PropulsionPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_Propulsion_OneRate(:, 7) ==  s );

                             %Average all rows corresponding to said single point in time and add to
                            %matrix containing averages for each point time
                            
    %All PF Coactivation
                            ViggianiBarrett_Coactivation_Propulsion_RATEMeans( RowtoFill_OnePerRate_PropulsionPhase , 1 : 10 ) = mean( ViggianiBarrett_Coactivation_Propulsion_OneRate( PropulsionPhase_OneDataPoint, :), 1 );


    %DF-PF Coactivation
                            ViggianiBarrett_DFPF_Coactivation_Propulsion_RATEMeans( RowtoFill_OnePerRate_PropulsionPhase , 1 : 10 ) = mean( ViggianiBarrett_DFPF_Coactivation_Propulsion_OneRate( PropulsionPhase_OneDataPoint, :), 1 );

                            
                            
    %Coactivation Between TS Only
                           ViggianiBarrett_TS_Coactivation_Propulsion_RATEMeans( RowtoFill_OnePerRate_PropulsionPhase , 1 : 10 ) = mean( ViggianiBarrett_TS_Coactivation_Propulsion_OneRate( PropulsionPhase_OneDataPoint, :), 1 );

                           
                           
    %Two Joint TS vs All PF Coactivation Data                              
                            ViggianiBarrett_2JntTS_Coactivation_Propulsion_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_2JntTS_Coactivation_Propulsion_OneRate( PropulsionPhase_OneDataPoint, :), 1 );

    %One Joint TS vs All PF Coactivation Data                              
                           ViggianiBarrett_1JntTS_Coactivation_Propulsion_RATEMeans( RowtoFill_OnePerRate_BrakingPhase , 1 : 10 ) = mean( ViggianiBarrett_1JntTS_Coactivation_Propulsion_OneRate( PropulsionPhase_OneDataPoint, :), 1 );
                           
                           
                           
                           
                            RowtoFill_OnePerRate_PropulsionPhase = RowtoFill_OnePerRate_PropulsionPhase + 1;

%% End S For Loop                            
                        end                                     
                        
                        
                        

%% Create and Write Tbles With Data Averaged For Each RATE

                         VariableNames_NoMeans = { ' Group_ID ', ' Participant_ID ', 'Limb_ID',  ' Trial_ID ', ' Hop_ID ', 'HoppingRate_ID' ,' Data_Point ' , ' Commonality ', ' Activity ', ' Coactivation ' };



                        ViggianiBarrett_Coactivation_EntireHopCycle_RATEMeans_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                        ViggianiBarrett_Coactivation_FlightPhase_RATEMeans_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                        ViggianiBarrett_Coactivation_ContactPhase_RATEMeans_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                        ViggianiBarrett_Coactivation_Braking_RATEMeans_Tble = array2table( ViggianiBarrett_Coactivation_Braking_RATEMeans, 'VariableNames', VariableNames_NoMeans );
                        
                        ViggianiBarrett_Coactivation_Propulsion_RATEMeans_Tble = array2table( ViggianiBarrett_Coactivation_Propulsion_RATEMeans, 'VariableNames', VariableNames_NoMeans );                      
                        
                          
                        

                        writetable(ViggianiBarrett_Coactivation_EntireHopCycle_RATEMeans_Tble, ['ViggianiBarrett_Coactivation_EntireHopCycle_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  , '.xlsx' ] );

                        writetable(ViggianiBarrett_Coactivation_FlightPhase_RATEMeans_Tble, ['ViggianiBarrett_Coactivation_FlightPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );

                        writetable(ViggianiBarrett_Coactivation_ContactPhase_RATEMeans_Tble, ['ViggianiBarrett_Coactivation_ContactPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  '.xlsx' ] );

                        writetable(ViggianiBarrett_Coactivation_Braking_RATEMeans_Tble, ['ViggianiBarrett_Coactivation_Braking_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  '.xlsx' ] );

                        writetable(ViggianiBarrett_Coactivation_Propulsion_RATEMeans_Tble, ['ViggianiBarrett_Coactivation_Propulsion_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  '.xlsx' ] );






                        ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_RATEMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                        ViggianiBarrett_DFPF_Coactivation_FlightPhase_RATEMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_FlightPhase_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                        ViggianiBarrett_DFPF_Coactivation_ContactPhase_RATEMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_ContactPhase_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                        ViggianiBarrett_DFPF_Coactivation_Braking_RATEMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_Braking_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         ViggianiBarrett_DFPF_Coactivation_Propulsion_RATEMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_Propulsion_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         
                         
                        

                        writetable(ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_RATEMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  '.xlsx' ] );

                        writetable(ViggianiBarrett_DFPF_Coactivation_FlightPhase_RATEMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_FlightPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,  '.xlsx' ] );

                        writetable(ViggianiBarrett_DFPF_Coactivation_ContactPhase_RATEMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_ContactPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
 
                        writetable(ViggianiBarrett_DFPF_Coactivation_Braking_RATEMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_BrakingPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
 
                         writetable(ViggianiBarrett_DFPF_Coactivation_Propulsion_RATEMeans_Tble, ['ViggianiBarrett_DFPF_Coactivation_PropulsionPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
                       
                        
                        
                         
                         
                         
                        
                        
                         
                         ViggianiBarrett_TS_Coactivation_Braking_RATEMeans_Tble = array2table( ViggianiBarrett_TS_Coactivation_Braking_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         ViggianiBarrett_TS_Coactivation_Propulsion_RATEMeans_Tble = array2table( ViggianiBarrett_TS_Coactivation_Propulsion_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         

                         
                        writetable(ViggianiBarrett_TS_Coactivation_Braking_RATEMeans_Tble, ['ViggianiBarrett_TS_Coactivation_BrakingPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
 
                         writetable(ViggianiBarrett_TS_Coactivation_Propulsion_RATEMeans_Tble, ['ViggianiBarrett_TS_Coactivation_PropulsionPhase_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
                                               
                         
                         
                         
                         
                         ViggianiBarrett_2JntTS_Coactivation_Braking_RATEMeans_Tble = array2table( ViggianiBarrett_2JntTS_Coactivation_Braking_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         ViggianiBarrett_2JntTS_Coactivation_Propulsion_RATEMeans_Tble = array2table( ViggianiBarrett_2JntTS_Coactivation_Propulsion_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         

                         
                        writetable(ViggianiBarrett_2JntTS_Coactivation_Braking_RATEMeans_Tble, ['ViggianiBarrett_2JntTS_Coactivation_Braking_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
 
                         writetable(ViggianiBarrett_2JntTS_Coactivation_Propulsion_RATEMeans_Tble, ['ViggianiBarrett_2JntTS_Coactivation_Propulsion_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );                         
                         
                         
                         
 
                         
                         
                         ViggianiBarrett_1JntTS_Coactivation_Braking_RATEMeans_Tble = array2table( ViggianiBarrett_1JntTS_Coactivation_Braking_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         ViggianiBarrett_1JntTS_Coactivation_Propulsion_RATEMeans_Tble = array2table( ViggianiBarrett_1JntTS_Coactivation_Propulsion_RATEMeans, 'VariableNames', VariableNames_NoMeans );

                         

                         
                        writetable(ViggianiBarrett_1JntTS_Coactivation_Braking_RATEMeans_Tble, ['ViggianiBarrett_1JntTS_Coactivation_Braking_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );
 
                         writetable(ViggianiBarrett_1JntTS_Coactivation_Propulsion_RATEMeans_Tble, ['ViggianiBarrett_1JntTS_Coactivation_Propulsion_RATEMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,   HoppingRate_ID{b}  ,'.xlsx' ] );                         
                         
                         
                         
  %% END B For Loop - Hopping Rate
 
                    end
                    
% %% Segment Out Data for One Hopping MTU - Entire Hop Cycle
% 
%                     EntireHopCycle_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_Coactivation_EntireHopCycle_forR( EntireHopCycle_IndicesforOneGroup, : );
% 
% 
%                     EntireHopCycle_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_IndicesforOneParticipant, : );
% 
% 
%                    EntireHopCycle_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_IndicesforOneLimb, : );
%                     
%                     
%                     
%                     EntireHopCycle_IndicesforOneMTU = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( :, 4 ) == m );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_OneMTU = ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_IndicesforOneMTU, : );
% 
% 
% 
%                     
%                     
%                     
%                     
%                     
%                     
%                     EntireHopCycle_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
% 
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( EntireHopCycle_DFPF_IndicesforOneGroup, : );
% 
% 
%                     EntireHopCycle_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
% 
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_DFPF_IndicesforOneParticipant, : );
% 
% 
%                    EntireHopCycle_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );
% 
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_DFPF_IndicesforOneLimb, : );
%                     
%                     
%                     
%                     EntireHopCycle_DFPF_IndicesforOneMTU = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( :, 4 ) == m );
% 
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneMTU = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_DFPF_IndicesforOneMTU, : );
% 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping MTU - Entire Hop Cycle
% 
%                     for s = 1 : MaxHopCycleLength_AllParticipants
% 
%                         EntireHopCycle_OneDataPoint = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneMTU(:, 7) ==  s );
% 
%                         ViggianiBarrett_Coactivation_EntireHopCycle_MTUMeans( RowtoFill_OnePerMTU , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_EntireHopCycle_OneMTU( EntireHopCycle_OneDataPoint, :), 1 );
% 
%                         
%                         
%                         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_MTUMeans( RowtoFill_OnePerMTU , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneMTU( EntireHopCycle_OneDataPoint, :), 1 );
%                         
%                         RowtoFill_OnePerMTU = RowtoFill_OnePerMTU + 1;
% 
%                     end
% 
% 
% %% Segment Out Data for One Hopping MTU - Flight Phase
% 
%                     FlightPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_FlightPhase_forR( :, 1 ) == k );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_Coactivation_FlightPhase_forR( FlightPhase_IndicesforOneGroup, : );
% 
% 
%                     FlightPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_IndicesforOneParticipant, : );
% 
% 
%                     FlightPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( FlightPhase_IndicesforOneLimb, : );
%                     
%                     
%                     
%                     FlightPhase_IndicesforOneMTU = find( ViggianiBarrett_Coactivation_FlightPhase_OneLimb( :, 4 ) == m );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_OneMTU = ViggianiBarrett_Coactivation_FlightPhase_OneLimb( FlightPhase_IndicesforOneMTU, : );
% 
% 
% 
%                     
%                     
%                     
%                     
%                     
%                     
%                     FlightPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( :, 1 ) == k );
% 
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( FlightPhase_DFPF_IndicesforOneGroup, : );
% 
% 
%                     FlightPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
% 
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_DFPF_IndicesforOneParticipant, : );
% 
% 
%                     FlightPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );
% 
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( FlightPhase_DFPF_IndicesforOneLimb, : );
%                     
%                     
%                     
%                     FlightPhase_DFPF_IndicesforOneMTU = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb( :, 4 ) == m );
% 
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneMTU = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb( FlightPhase_DFPF_IndicesforOneMTU, : );
%                     
%                     
%     %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping MTU - Flight Phase
% 
%                     for s = 1 : MaxFlightPhaseLength_AllParticipants
% 
%                         FlightPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_FlightPhase_OneMTU(:, 7) ==  s );
% 
%                         ViggianiBarrett_Coactivation_FlightPhase_MTUMeans( RowtoFill_OnePerMTU_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_FlightPhase_OneMTU( FlightPhase_OneDataPoint, :), 1 );
% 
%                         
%                         
%                         ViggianiBarrett_DFPF_Coactivation_FlightPhase_MTUMeans( RowtoFill_OnePerMTU_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneMTU( FlightPhase_OneDataPoint, :), 1 );
%                         
%                         RowtoFill_OnePerMTU_FlightPhase = RowtoFill_OnePerMTU_FlightPhase + 1;
% 
%                     end
% 
% 
% 
%     %% Segment Out Data for One Hopping MTU - Contact Phase
% 
%                     ContactPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_ContactPhase_forR( :, 1 ) == k );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_Coactivation_ContactPhase_forR( ContactPhase_IndicesforOneGroup, : );
% 
% 
%                     ContactPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_IndicesforOneParticipant, : );
% 
% 
%                     ContactPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( ContactPhase_IndicesforOneLimb, : );
%                     
%                     
%                     
%                     ContactPhase_IndicesforOneMTU = find( ViggianiBarrett_Coactivation_ContactPhase_OneLimb( :, 4 ) == m );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_OneMTU = ViggianiBarrett_Coactivation_ContactPhase_OneLimb( ContactPhase_IndicesforOneMTU, : );
% 
% 
% 
%                     
%                     
%                     
%                     
%                     ContactPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( :, 1 ) == k );
% 
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( ContactPhase_DFPF_IndicesforOneGroup, : );
% 
% 
%                     ContactPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
% 
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_DFPF_IndicesforOneParticipant, : );
% 
% 
%                     ContactPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );
% 
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( ContactPhase_DFPF_IndicesforOneLimb, : );
%                     
%                     
%                     
%                     ContactPhase_DFPF_IndicesforOneMTU = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb( :, 4 ) == m );
% 
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneMTU = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb( ContactPhase_DFPF_IndicesforOneMTU, : );
%                     
%                     
%     %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping MTU - Contact Phase
% 
%                     for s = 1 : MaxContactPhaseLength_AllParticipants
% 
%                         ContactPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_ContactPhase_OneMTU(:, 7) ==  s );
% 
%                         ViggianiBarrett_Coactivation_ContactPhase_MTUMeans( RowtoFill_OnePerMTU_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_ContactPhase_OneMTU( ContactPhase_OneDataPoint, :), 1 );
% 
%                         
%                         
%                         ViggianiBarrett_DFPF_Coactivation_ContactPhase_MTUMeans( RowtoFill_OnePerMTU_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneMTU( ContactPhase_OneDataPoint, :), 1 );
%                         
%                         RowtoFill_OnePerMTU_ContactPhase = RowtoFill_OnePerMTU_ContactPhase + 1;
% 
%                     end               
% 
% 
%                     
%                     
% %% Create and Write Tbles With Data Averaged For Each MTU
%  
%                     ViggianiBarrett_Coactivation_EntireHopCycle_MTUMeans_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_MTUMeans, 'VariableNames', VariableNames );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_MTUMeans_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_MTUMeans, 'VariableNames', VariableNames );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_MTUMeans_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_MTUMeans, 'VariableNames', VariableNames );
% 
% 
% 
%                     writetable(ViggianiBarrett_Coactivation_EntireHopCycle_MTUMeans_Tble, [ 'ViggianiBarrett_Coactivation_EntireHopCycle_MTUMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,  '.xlsx' ] );
% 
%                     writetable(ViggianiBarrett_Coactivation_FlightPhase_MTUMeans_Tble, [ 'ViggianiBarrett_Coactivation_FlightPhase_MTUMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,  '.xlsx' ] );
% 
%                     writetable(ViggianiBarrett_Coactivation_ContactPhase_MTUMeans_Tble, [ 'ViggianiBarrett_Coactivation_ContactPhase_MTUMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,MTUID{m} ,'.xlsx' ] );
%                     
%                                         
%                     
%                     
%                     
%                     
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_MTUMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_MTUMeans, 'VariableNames', VariableNames );
% 
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_MTUMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_FlightPhase_MTUMeans, 'VariableNames', VariableNames );
% 
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_MTUMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_ContactPhase_MTUMeans, 'VariableNames', VariableNames );
% 
% 
% 
%                     writetable(ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_MTUMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_MTUMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,  '.xlsx' ] );
% 
%                     writetable(ViggianiBarrett_DFPF_Coactivation_FlightPhase_MTUMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_FlightPhase_MTUMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,  '.xlsx' ] );
% 
%                     writetable(ViggianiBarrett_DFPF_Coactivation_ContactPhase_MTUMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_ContactPhase_MTUMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}  ,MTUID{m} ,'.xlsx' ] );
%                     
                               



                
                
                
                
                
                
                
%  %% Segment Out Data for One LIMB - Entire Hop Cycle
% 
%                 EntireHopCycle_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_Coactivation_EntireHopCycle_forR( EntireHopCycle_IndicesforOneGroup, : );
% 
%                 
%                 
%                 EntireHopCycle_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_IndicesforOneParticipant, : );
%                 
%                
%                 
%                 EntireHopCycle_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );
%         
%                 ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_IndicesforOneLimb, : );
%                 
% 
%                 
%                 
%                 
%                 
%                 EntireHopCycle_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( EntireHopCycle_DFPF_IndicesforOneGroup, : );
% 
%                 
%                 
%                 EntireHopCycle_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_DFPF_IndicesforOneParticipant, : );
%                 
%                
%                 
%                 EntireHopCycle_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( :, 3 ) == a );
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_DFPF_IndicesforOneLimb, : );
%    
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One LIMB - Entire Hop Cycle
% 
%                 for s = 1 : MaxHopCycleLength_AllParticipants
% 
%                     EntireHopCycle_OneDataPoint = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_LimbMeans( RowtoFill_OnePerLimb , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_OneDataPoint, :), 1 );
%                     
%                     
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_LimbMeans( RowtoFill_OnePerLimb , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneLimb( EntireHopCycle_OneDataPoint, :), 1 );
% 
%                     RowtoFill_OnePerLimb = RowtoFill_OnePerLimb + 1;
% 
%                 end
%                 
% 
% %% Segment Out Data for One LIMB - Flight Phase
% 
%                 FlightPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_FlightPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_Coactivation_FlightPhase_forR( FlightPhase_IndicesforOneGroup, : );
% 
%                 
%                 FlightPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_IndicesforOneParticipant, : );
%                 
%                 
%                 
%                 FlightPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );
%         
%                 ViggianiBarrett_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_IndicesforOneLimb, : );
% 
% 
%                 
%                 
%                 
%                 
%                 FlightPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( FlightPhase_DFPF_IndicesforOneGroup, : );
% 
%                 
%                 FlightPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_DFPF_IndicesforOneParticipant, : );
%                 
%                 
%                 
%                 FlightPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( :, 3 ) == a );
%         
%                 ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_DFPF_IndicesforOneLimb, : );
%                 
%                 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One LIMB - Flight Phase
% 
%                 for s = 1 : MaxFlightPhaseLength_AllParticipants
% 
%                     FlightPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_LimbMeans( RowtoFill_OnePerLimb_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( FlightPhase_OneDataPoint, :), 1 );
% 
%                     
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_LimbMeans( RowtoFill_OnePerLimb_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( FlightPhase_OneDataPoint, :), 1 );
%                     
%                     RowtoFill_OnePerLimb_FlightPhase = RowtoFill_OnePerLimb_FlightPhase + 1;
% 
%                 end
%                 
%                 
%                 
% %% Segment Out Data for One LIMB - Contact Phase
% 
%                 ContactPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_ContactPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_Coactivation_ContactPhase_forR( ContactPhase_IndicesforOneGroup, : );
% 
%                 
%                 ContactPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_IndicesforOneParticipant, : );
%                 
%                 
%                 
%                 ContactPhase_IndicesforOneLimb = find( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );
%         
%                 ViggianiBarrett_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_IndicesforOneLimb, : );
%                 
% 
%                 
%                 
%                 
%                 ContactPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( ContactPhase_DFPF_IndicesforOneGroup, : );
% 
%                 
%                 ContactPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_DFPF_IndicesforOneParticipant, : );
%                 
%                 
%                 
%                 ContactPhase_DFPF_IndicesforOneLimb = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( :, 3 ) == a );
%         
%                 ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneLimb = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_DFPF_IndicesforOneLimb, : );
%      
%                 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One LIMB - Entire Hop Cycle
% 
%                 for s = 1 : MaxContactPhaseLength_AllParticipants
% 
%                     ContactPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_LimbMeans( RowtoFill_OnePerLimb_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( ContactPhase_OneDataPoint, :), 1 );
% 
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_LimbMeans( RowtoFill_OnePerLimb_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( ContactPhase_OneDataPoint, :), 1 );
%                     
%                     RowtoFill_OnePerLimb_ContactPhase = RowtoFill_OnePerLimb_ContactPhase + 1;
% 
%                 end                  
%                 
%                 
%                 
% %% Create and Write Tbles With Data Averaged For Each LIMB
%  
%         ViggianiBarrett_Coactivation_EntireHopCycle_LMeans_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_LimbMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_Coactivation_FlightPhase_LMeans_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_LimbMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_Coactivation_ContactPhase_LMeans_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_LimbMeans, 'VariableNames', VariableNames );
% 
% 
% 
%         writetable(ViggianiBarrett_Coactivation_EntireHopCycle_LMeans_Tble, [ 'ViggianiBarrett_Coactivation_EntireHopCycle_ParticipantMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}, '.xlsx' ] );
% 
%         writetable(ViggianiBarrett_Coactivation_FlightPhase_LMeans_Tble, [ 'ViggianiBarrett_Coactivation_FlightPhase_ParticipantMeans_Tble',  GroupList{k} ,ParticipantList{l}  ,LimbID{a}, '.xlsx' ] );
% 
%         writetable(ViggianiBarrett_Coactivation_ContactPhase_LMeans_Tble, [ 'ViggianiBarrett_Coactivation_ContactPhase_ParticipantMeans_Tble',  GroupList{k} ,ParticipantList{l}  ,LimbID{a}, '.xlsx' ] );                
%                 
%                 
%                 
%                 
%                 
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_LMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_LimbMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_DFPF_Coactivation_FlightPhase_LMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_FlightPhase_LimbMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_DFPF_Coactivation_ContactPhase_LMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_ContactPhase_LimbMeans, 'VariableNames', VariableNames );
% 
% 
% 
%         writetable(ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_LMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_EntireHop_ParticipantMeans_Tble', GroupList{k} ,ParticipantList{l}  ,LimbID{a}, '.xlsx' ] );
% 
%         writetable(ViggianiBarrett_DFPF_Coactivation_FlightPhase_LMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_FlightPhase_ParticipantMeans_Tble',  GroupList{k} ,ParticipantList{l}  ,LimbID{a}, '.xlsx' ] );
% 
%         writetable(ViggianiBarrett_DFPF_Coactivation_ContactPhase_LMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_ContactPhase_ParticipantMeans_Tble',  GroupList{k} ,ParticipantList{l}  ,LimbID{a}, '.xlsx' ] );  
%         
        
 %% Segment Out Data for One Hopping PARTICIPANT - Entire Hop Cycle

%                 EntireHopCycle_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_Coactivation_EntireHopCycle_forR( EntireHopCycle_IndicesforOneGroup, : );
% 
%                 
%                 EntireHopCycle_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_IndicesforOneParticipant, : );
%                 
% 
%                 
%                 
%                 
%                 
%                 
%                 EntireHopCycle_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( EntireHopCycle_DFPF_IndicesforOneGroup, : );
% 
%                 
%                 EntireHopCycle_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_DFPF_IndicesforOneParticipant, : );
%                 
%                 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Participant - Entire Hop Cycle
% 
%                 for s = 1 : MaxHopCycleLength_AllParticipants
% 
%                     EntireHopCycle_OneDataPoint = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_ParticipantMeans( RowtoFill_OnePerParticipant , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_OneDataPoint, :), 1 );
% 
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_EntireHop_ParticipantMeans( RowtoFill_OnePerParticipant , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneParticipant( EntireHopCycle_OneDataPoint, :), 1 );
%                     
%                     RowtoFill_OnePerParticipant = RowtoFill_OnePerParticipant + 1;
% 
%                 end
%                 
% 
% %% Segment Out Data for One Hopping Participant - Flight Phase
% 
%                 FlightPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_FlightPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_Coactivation_FlightPhase_forR( FlightPhase_IndicesforOneGroup, : );
% 
%                 
%                 FlightPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_IndicesforOneParticipant, : );
% 
% 
%                 
%                 
%                 
%                 
%                 
%                 FlightPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( FlightPhase_DFPF_IndicesforOneGroup, : );
% 
%                 
%                 FlightPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_DFPF_IndicesforOneParticipant, : );
%                 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Participant - Flight Phase
% 
%                 for s = 1 : MaxFlightPhaseLength_AllParticipants
% 
%                     FlightPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_ParticipantMeans( RowtoFill_OnePerParticipant_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_FlightPhase_OneParticipant( FlightPhase_OneDataPoint, :), 1 );
% 
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_ParticipantMeans( RowtoFill_OnePerParticipant_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneParticipant( FlightPhase_OneDataPoint, :), 1 );
%                     
%                     RowtoFill_OnePerParticipant_FlightPhase = RowtoFill_OnePerParticipant_FlightPhase + 1;
% 
%                 end
%                 
%                 
%                 
% %% Segment Out Data for One Hopping Participant - Contact Phase
% 
%                 ContactPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_ContactPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_Coactivation_ContactPhase_forR( ContactPhase_IndicesforOneGroup, : );
% 
%                 
%                 ContactPhase_IndicesforOneParticipant = find( ViggianiBarrett_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_IndicesforOneParticipant, : );
%                 
% 
%                 
%                 
%                 
%                 
%                 
%                                 ContactPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( ContactPhase_DFPF_IndicesforOneGroup, : );
% 
%                 
%                 ContactPhase_DFPF_IndicesforOneParticipant = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( :, 2 ) == l );
%         
%                 ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant = ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_DFPF_IndicesforOneParticipant, : );
%    
%                 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Participant - Entire Hop Cycle
% 
%                 for s = 1 : MaxContactPhaseLength_AllParticipants
% 
%                     ContactPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_ParticipantMeans( RowtoFill_OnePerParticipant_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_ContactPhase_OneParticipant( ContactPhase_OneDataPoint, :), 1 );
% 
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_ContactPhase_ParticipantMeans( RowtoFill_OnePerParticipant_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneParticipant( ContactPhase_OneDataPoint, :), 1 );
%                     
%                     RowtoFill_OnePerParticipant_ContactPhase = RowtoFill_OnePerParticipant_ContactPhase + 1;
% 
%                 end           
 
%% End A For Loop - for LimbID   
                
           end
           
           
%% Create and Write Tbles With Data Averaged For Each Participant
 
%         ViggianiBarrett_Coactivation_EntireHopCycle_PMeans_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_ParticipantMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_Coactivation_FlightPhase_PMeans_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_ParticipantMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_Coactivation_ContactPhase_PMeans_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_ParticipantMeans, 'VariableNames', VariableNames );
% 
% 
% 
%         writetable(ViggianiBarrett_Coactivation_EntireHopCycle_PMeans_Tble, [ 'ViggianiBarrett_Coactivation_EntireHopCycle_ParticipantMeans_Tble', ParticipantList{l}  ,'.xlsx' ] );
% 
%         writetable(ViggianiBarrett_Coactivation_FlightPhase_PMeans_Tble, [ 'ViggianiBarrett_Coactivation_FlightPhase_ParticipantMeans_Tble', ParticipantList{l}  ,'.xlsx' ] );
% 
%         writetable(ViggianiBarrett_Coactivation_ContactPhase_PMeans_Tble, [ 'ViggianiBarrett_Coactivation_ContactPhase_ParticipantMeans_Tble', ParticipantList{l}  ,'.xlsx' ] );
% 
%    
%         
%         
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_PMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_EntireHop_ParticipantMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_DFPF_Coactivation_FlightPhase_PMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_FlightPhase_ParticipantMeans, 'VariableNames', VariableNames );
% 
%         ViggianiBarrett_DFPF_Coactivation_ContactPhase_PMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_ContactPhase_ParticipantMeans, 'VariableNames', VariableNames );
% 
% 
% 
%         writetable(ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_PMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_EntireHop_ParticipantMeans_Tble', ParticipantList{l}  ,'.xlsx' ] );
% 
%         writetable(ViggianiBarrett_DFPF_Coactivation_FlightPhase_PMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_FlightPhase_ParticipantMeans_Tble', ParticipantList{l}  ,'.xlsx' ] );
% 
%         writetable(ViggianiBarrett_DFPF_Coactivation_ContactPhase_PMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_ContactPhase_ParticipantMeans_Tble', ParticipantList{l}  ,'.xlsx' ] );

        
%% End L For Loop - for Participant List
        end%End l for loop
        
%    %% Segment Out Data for One Hopping GROUP - Entire Hop Cycle
% 
%                 EntireHopCycle_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_Coactivation_EntireHopCycle_forR( EntireHopCycle_IndicesforOneGroup, : );
% 
%                 
% 
%                 
%                 
%                 
%                 
%                                 EntireHopCycle_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup = ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_forR( EntireHopCycle_DFPF_IndicesforOneGroup, : );
% 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Group - Entire Hop Cycle
% 
%                 for s = 1 : MaxHopCycleLength_AllParticipants
% 
%                     EntireHopCycle_OneDataPoint = find( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_EntireHopCycle_GroupMeans( RowtoFill_OnePerGroup , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_OneDataPoint, :), 1 );
%                     
%                     
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_GroupMeans( RowtoFill_OnePerGroup , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_OneGroup( EntireHopCycle_OneDataPoint, :), 1 );
% 
%                     RowtoFill_OnePerGroup = RowtoFill_OnePerGroup + 1;
% 
%                 end
%                 
% 
% %% Segment Out Data for One Hopping Group - Flight Phase
% 
%                 FlightPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_FlightPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_Coactivation_FlightPhase_forR( FlightPhase_IndicesforOneGroup, : );
% 
%                 
%                 
%                 
%                 
%                 
%                 FlightPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_FlightPhase_forR( FlightPhase_DFPF_IndicesforOneGroup, : );
% 
%                 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Group - Flight Phase
% 
%                 for s = 1 : MaxFlightPhaseLength_AllParticipants
% 
%                     FlightPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_FlightPhase_OneGroup(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_FlightPhase_GroupMeans( RowtoFill_OnePerGroup_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_FlightPhase_OneGroup( FlightPhase_OneDataPoint, :), 1 );
% 
%                     
%                     
%                     
%                     ViggianiBarrett_DFPF_Coactivation_FlightPhase_GroupMeans( RowtoFill_OnePerGroup_FlightPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_FlightPhase_OneGroup( FlightPhase_OneDataPoint, :), 1 );
% 
%                     
%                     RowtoFill_OnePerGroup_FlightPhase = RowtoFill_OnePerGroup_FlightPhase + 1;
% 
%                 end
%                 
%                 
%                 
% %% Segment Out Data for One Hopping Group - Contact Phase
% 
%                 ContactPhase_IndicesforOneGroup = find( ViggianiBarrett_Coactivation_ContactPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_Coactivation_ContactPhase_forR( ContactPhase_IndicesforOneGroup, : );
% 
% 
%                 
%                 
%                 
%                                 ContactPhase_DFPF_IndicesforOneGroup = find( ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( :, 1 ) == k );
%         
%                 ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup = ViggianiBarrett_DFPF_Coactivation_ContactPhase_forR( ContactPhase_DFPF_IndicesforOneGroup, : );
% 
% 
% %% For Loop - Take Means of Viggianni-Barrett Coactivation Data for One Hopping Group - Contact Phase
% 
%                 for s = 1 : MaxContactPhaseLength_AllParticipants
% 
%                     ContactPhase_OneDataPoint = find( ViggianiBarrett_Coactivation_ContactPhase_OneGroup(:, 7) ==  s );
% 
%                     ViggianiBarrett_Coactivation_ContactPhase_GroupMeans( RowtoFill_OnePerGroup_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_Coactivation_ContactPhase_OneGroup( ContactPhase_OneDataPoint, :), 1 );
% 
%                     
%                     
%                   ViggianiBarrett_DFPF_Coactivation_ContactPhase_GroupMeans( RowtoFill_OnePerGroup_ContactPhase , 1 : 11 ) = mean( ViggianiBarrett_DFPF_Coactivation_ContactPhase_OneGroup( ContactPhase_OneDataPoint, :), 1 );
% 
%                                         
%                     RowtoFill_OnePerGroup_ContactPhase = RowtoFill_OnePerGroup_ContactPhase + 1;
% 
%                 end
%     
%     
%     
%     VariableNames = { ' Group_ID ', ' Participant_ID ', 'Limb_ID' ,' MTU_ID ', ' Trial_ID ', ' Hop_ID ', 'HoppingRate_ID'  ,' Data_Point ' , ' Commonality ', ' Activity ', ' Coactivation ' };
%                 
%     
%      %% Create and Write Tbles With Data Averaged For Each Group
%  
%     ViggianiBarrett_Coactivation_EntireHopCycle_GroupMeans_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_GroupMeans, 'VariableNames', VariableNames );
% 
%     ViggianiBarrett_Coactivation_FlightPhase_GroupMeans_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_GroupMeans, 'VariableNames', VariableNames );
% 
%     ViggianiBarrett_Coactivation_ContactPhase_GroupMeans_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_GroupMeans, 'VariableNames', VariableNames );
%     
%     
%     
%     writetable(ViggianiBarrett_Coactivation_EntireHopCycle_GroupMeans_Tble, [ 'ViggianiBarrett_Coactivation_EntireHopCycle_GroupMeans_Tble', GroupList{k}  ,'.xlsx' ] );
%     
%     writetable(ViggianiBarrett_Coactivation_FlightPhase_GroupMeans_Tble, [ 'ViggianiBarrett_Coactivation_FlightPhase_GroupMeans_Tble', GroupList{k}    '.xlsx' ]);
%     
%     writetable(ViggianiBarrett_Coactivation_ContactPhase_GroupMeans_Tble, [ 'ViggianiBarrett_Coactivation_ContactPhase_GroupMeans_Tble', GroupList{k}    '.xlsx' ]); 
%                 
%                 
%     
%     
%     
%     
%     
%     
%     
%         ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_GroupMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_GroupMeans, 'VariableNames', VariableNames );
% 
%     ViggianiBarrett_DFPF_Coactivation_FlightPhase_GroupMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_FlightPhase_GroupMeans, 'VariableNames', VariableNames );
% 
%     ViggianiBarrett_DFPF_Coactivation_ContactPhase_GroupMeans_Tble = array2table( ViggianiBarrett_DFPF_Coactivation_ContactPhase_GroupMeans, 'VariableNames', VariableNames );
%     
%     
%     
%     writetable(ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_GroupMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_EntireHopCycle_GroupMeans_Tble', GroupList{k}  ,'.xlsx' ] );
%     
%     writetable(ViggianiBarrett_DFPF_Coactivation_FlightPhase_GroupMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_FlightPhase_GroupMeans_Tble', GroupList{k}    '.xlsx' ]);
%     
%     writetable(ViggianiBarrett_DFPF_Coactivation_ContactPhase_GroupMeans_Tble, [ 'ViggianiBarrett_DFPF_Coactivation_ContactPhase_GroupMeans_Tble', GroupList{k}    '.xlsx' ]); 
                
 %% End K for loop - for GroupList
    end
    
    
 
                        
 %% Create and Write Tbles With Data For Each Individual Hop
 
%     ViggianiBarrett_Coactivation_EntireHopCycle_Tble = array2table( ViggianiBarrett_Coactivation_EntireHopCycle_forR, 'VariableNames', VariableNames );
% 
%     ViggianiBarrett_Coactivation_FlightPhase_Tble = array2table( ViggianiBarrett_Coactivation_FlightPhase_forR, 'VariableNames', VariableNames );
% 
%     ViggianiBarrett_Coactivation_ContactPhase_Tble = array2table( ViggianiBarrett_Coactivation_ContactPhase_forR, 'VariableNames', VariableNames );
%     
%     
%     
%     writetable(ViggianiBarrett_Coactivation_EntireHopCycle_Tble, [ 'ViggianiBarrett_Coactivation_EntireHopCycle_Tble', GroupList{k}  ,'.xlsx' ] );
%     
%     writetable(ViggianiBarrett_Coactivation_FlightPhase_Tble, [ 'ViggianiBarrett_Coactivation_FlightPhase_Tble.xlsx');
%     
%     writetable(ViggianiBarrett_Coactivation_ContactPhase_Tble, [ 'ViggianiBarrett_Coactivation_ContactPhase_Tble.xlsx');
    
    
  

%% End J For Loop - for Quals Data
end %End j for loop                
                


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 6',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end




%% SECTION 7 - Take Participant Averages of Coactivation Ratio Data

%Want to clear the errors for the new section
lasterror = [];




    %Need to know how many SD columns we need for AllTS_CoactivationRatio
    NumberofSD_Columns =  size( AllTS_CoactivationRatio, 2 ) - 6;

    %Create a vector for filling in the SD columns
    ColumntoFill_SD_ParticipantMeans = ( size( AllTS_CoactivationRatio, 2 )  + 1 ) : ( size( AllTS_CoactivationRatio, 2 ) + NumberofSD_Columns ) ;

    %Initialize matrices to hold joint power and joint behavior index means
    AllTS_CoactivationRatio_ParticipantMeansPerRate = NaN( 1, ColumntoFill_SD_ParticipantMeans( end ) ); 

 
    %Use these to tell the code which row of the participant means matrices to fill
    RowtoFill_CoactivationRatio_ParticipantMeans = 1;



% Begin J For Loop - Create List of All Groups

for j = 1 : numel(QualvsPostQualData)
    
    ListofAllGroups = getfield(David_DissertationEMGDataStructure, QualvsPostQualData{j} );

%% Begin K For Loop - Create List of All Participants Within A Given Group

    for k = 1: numel( GroupList )
        
        ListofParticipants_GroupJ = getfield( ListofAllGroups, GroupList{k} );
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{ k }, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        %Find all rows of AllTS_CoactivationRatio that correspond to Group K
        RowIndices_OneGroup = find( AllTS_CoactivationRatio( :, 1) == k );
        
        %Make a new matrix containing only the coactivation data for Group K
        CoactivationRatio_OneGroup = AllTS_CoactivationRatio( RowIndices_OneGroup, :);
        
        
        
        
 %% Begin L For Loop - Create List of Variables within a Given Participant      
        
        for l = 1 : numel(ParticipantList)
            
%% Set Limb ID, Hopping Rate            
            
             %Visual 3D kinematic variables are named as RAnkle or LAnkle. For the ATx participants,
            %the data structure labels are Involved and NonInvolved. For indexing into the V3D
            %Tbles, we need to define whether the Involved limb is Right or Left.
            if strcmp( ParticipantList{ l }, 'ATx07'  ) || strcmp( ParticipantList{ l }, 'ATx08'  ) || strcmp( ParticipantList{ l }, 'ATx10'  ) || strcmp( ParticipantList{ l }, 'ATx17'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx18'  ) || strcmp( ParticipantList{ l }, 'ATx21'  ) || strcmp( ParticipantList{ l }, 'ATx25'  ) || strcmp( ParticipantList{ l }, 'ATx36'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx38'  ) || strcmp( ParticipantList{ l }, 'ATx39'  ) || strcmp( ParticipantList{ l }, 'ATx41'  ) || strcmp( ParticipantList{ l }, 'ATx49'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx74'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ l }, 'ATx24'  ) 
                
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];




            elseif strcmp( ParticipantList{ l }, 'ATx19'  ) || strcmp( ParticipantList{ l }, 'ATx65'  )
             
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
                HoppingRate_ID_forTble = [ 2, 2.33 ];



            elseif strcmp( ParticipantList{ l }, 'ATx12'  ) || strcmp( ParticipantList{ l }, 'ATx14'  ) || strcmp( ParticipantList{ l }, 'ATx27'  ) || strcmp( ParticipantList{ l }, 'ATx34'  ) || strcmp( ParticipantList{ l }, 'ATx44'  ) ||...
                    strcmp( ParticipantList{ l }, 'ATx50'  ) || strcmp( ParticipantList{ l }, 'ATx100'  )
             
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ]; 
                
                



            elseif strcmp( ParticipantList{ l }, 'HC11'  ) || strcmp( ParticipantList{n}, 'HC42'  )
                
                %Process only the right limb of HC11
                LimbID = { 'LeftLimb', 'RightLimb' };
                
                %Will use this variable to pull out the joint data from the Visual 3D output. Need
                %to set this variable because the values may differ from the ATx group. If we don't
                %set it differently for HC01, the values may be wrong
                LimbID_forV3DOutput = { 'LeftLimb', 'RightLimb' };
                
                %HC11 has only the 2.0 and 2.33 Hz hopping rates
                HoppingRate_ID = {'TwoHz', 'TwoPoint3Hz'};
                
                %These are numeric values of the hopping rates, for filling in the matrices
                %containing data from all participants. Here, 0 = preferred Hz
                 HoppingRate_ID_forTble = [ 2, 2.33 ];
                
                
                
                

            elseif strcmp( ParticipantList{ l }, 'HC17'  ) || strcmp( ParticipantList{ l }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC32'  ) || strcmp( ParticipantList{ l }, 'HC34'  ) || strcmp( ParticipantList{ l }, 'HC45'  ) ||...
                    strcmp( ParticipantList{ l }, 'HC48'  ) ||strcmp( ParticipantList{ l }, 'HC65'  ) || strcmp( ParticipantList{ l }, 'HC68'  )
                
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
                HoppingRate_ID_forTble = [ 0, 2, 2.33 ];


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
                 HoppingRate_ID_forTble = [ 0, 2, 2.33 ];
                
                               
            end
            
            
            
            
            %Find all rows of AllTS_CoactivationRatio that correspond to Participant L
             RowIndices_OneParticipant = find( CoactivationRatio_OneGroup( :, 2) == l );
        
             %Make a new matrix containing only the coactivation data for Group K
            CoactivationRatio_OneParticipant = CoactivationRatio_OneGroup( RowIndices_OneParticipant, :);
            
            %Create a vector containing the Limb IDs for CoactivationRatio_OneParticipant. Use
            %unique() to get rid of repeating values
            UniqueLimbID = unique( CoactivationRatio_OneParticipant( :, 3 ) );
            
            %Create vector containing the Limb IDs for CoactivationRatio_OneGroup. Use unique() to
            %get rid of repeating values
            UniqueLimbID_OneGroup = unique( CoactivationRatio_OneGroup( :, 3 ) );
            
            
            
            
            
            
%% Begin A For Loop - Create List of Variables for A Given Limb            
            
            for a = 1 : numel( UniqueLimbID )
                    
                %Find all rows of AllTS_CoactivationRatio that correspond to Participant L
                 RowIndices_OneLimb = find( CoactivationRatio_OneParticipant( :, 3) == a );

                 %Make a new matrix containing only the coactivation data for Group K
                CoactivationRatio_OneLimb = CoactivationRatio_OneParticipant( RowIndices_OneLimb, :);

                %Create a vector containing the Limb IDs for CoactivationRatio_OneParticipant. Use
                %unique() to get rid of repeating values
                UniqueHoppingRateID_OneParticipant = unique( CoactivationRatio_OneLimb( :, 6 ) );
                

                
                
                
                
                
%% Begin B For Loop - Hopping Rates                    
                    
                    for b = 1 : numel( UniqueHoppingRateID_OneParticipant )                   
                        
                        %Find all rows of AllTS_CoactivationRatio that correspond to Participant L
                         RowIndices_OneHoppingRate = find( CoactivationRatio_OneLimb( :, 6) == UniqueHoppingRateID_OneParticipant( b ) );

                         %Make a new matrix containing only the coactivation data for Group K
                        CoactivationRatio_OneHoppingRate = CoactivationRatio_OneLimb( RowIndices_OneHoppingRate, :);


                        %Take the mean of all columns of AllTS_CoactivationRatio, EXCEPT for the 5th
                        %column - this contains the hop number
                        AllTS_CoactivationRatio_ParticipantMeansPerRate( RowtoFill_CoactivationRatio_ParticipantMeans, 1 : size( AllTS_CoactivationRatio, 2 ) ) = mean( CoactivationRatio_OneHoppingRate, 1, 'omitnan' );
                        
                        %For loop to fill in the SD column. Only take standard deviation for Column 7+
                        for z = 1 : numel( ColumntoFill_SD_ParticipantMeans )

                            %Find the standard deviation of the 6th through 28th columns of
                            %AllTS_CoactivationRatio. These columns contain the data
                            AllTS_CoactivationRatio_ParticipantMeansPerRate( RowtoFill_CoactivationRatio_ParticipantMeans, ColumntoFill_SD_ParticipantMeans( z ) ) = std( CoactivationRatio_OneHoppingRate( :, ColumntoFill_SD_ParticipantMeans( z ) - 87 ), 1, 'omitnan' );
                        
                        end
                        
                        
                         %Add 1 to RowtoFill_CoactivationRatio_ParticipantMeans so that the next loop fills
                        %in the next row of AllTS_CoactivationRatio_ParticipantMeansPerRate
                        RowtoFill_CoactivationRatio_ParticipantMeans = RowtoFill_CoactivationRatio_ParticipantMeans + 1;
                        
                        
                        
                        
                        
%%  END B For Loop - Hopping Rate                        
                    end
                        
%% END A For Loop - Limb ID                    
            end
                
%% END L For Loop - Participant List            
        end

%% END K For Loop - Group List        
    end
    
%% END J For Loop    
end



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 7',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end















%% SECTION 8 - Take Group Averages of Coactivation Ratio Data

%Want to clear the errors for the new section
lasterror = [];



%Need to know how many SD columns we need for AllTS_CoactivationRatio
NumberofSD_Columns =  size( AllTS_CoactivationRatio, 2 ) - 6;

%Create a vector for filling in the SD columns
ColumntoFill_SD_GroupMeans = ( size( AllTS_CoactivationRatio, 2 ) + 1 ) : ( size( AllTS_CoactivationRatio, 2 ) + NumberofSD_Columns ) ;

%Initialize matrices to hold joint power and joint behavior index means
AllTS_CoactivationRatio_GroupMeansPerRate = NaN( 1, ColumntoFill_SD_GroupMeans( end ) ); 
 
%Use these to tell the code which row of the participant and group means matrices to fill
RowtoFill_CoactivationRatio_GroupMeans = 1;



% Begin J For Loop - Create List of All Groups

for j = 1 : numel(QualvsPostQualData)
    
    ListofAllGroups = getfield(David_DissertationEMGDataStructure, QualvsPostQualData{j} );

%% Begin K For Loop - Create List of All Participants Within A Given Group

    for k = 1: numel( GroupList )
        
        ListofParticipants_GroupJ = getfield( ListofAllGroups, GroupList{ k } );
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{ k }, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        %Find all rows of AllTS_CoactivationRatio that correspond to Group K
        RowIndices_OneGroup = find( AllTS_CoactivationRatio( :, 1) == k );
        
        %Make a new matrix containing only the coactivation data for Group K
        CoactivationRatio_OneGroup = AllTS_CoactivationRatio( RowIndices_OneGroup, :);
        

        
        
            
            %Create vector containing the Limb IDs for CoactivationRatio_OneGroup. Use unique() to
            %get rid of repeating values
            UniqueLimbID_OneGroup = unique( CoactivationRatio_OneGroup( :, 3 ) );
            
            
            
%% Begin A For Loop - Create List of Variables for A Given Limb            
            
            for a = 1 : numel( UniqueLimbID )
                    
                
                %Find all rows of AllTS_CoactivationRatio that correspond to Participant L
                 RowIndices_OneLimb = find( CoactivationRatio_OneGroup( :, 3) == a );

                 %Make a new matrix containing only the coactivation data for Group K
                CoactivationRatio_OneLimb = CoactivationRatio_OneGroup( RowIndices_OneLimb, :);

                %Create a vector containing the Limb IDs for CoactivationRatio_OneParticipant. Use
                %unique() to get rid of repeating values
                UniqueHoppingRateID_OneLimb = unique( CoactivationRatio_OneLimb( :, 6 ) );
                

                            
                
                
                
%% Begin B For Loop - Hopping Rates                    
                    
                    for b = 1 : numel( UniqueHoppingRateID_OneLimb )                   
                        
                        %Find all rows of AllTS_CoactivationRatio that correspond to Participant L
                         RowIndices_OneHoppingRate = find( CoactivationRatio_OneLimb( :, 6) == UniqueHoppingRateID_OneLimb( b ) );

                         %Make a new matrix containing only the coactivation data for Group K
                        CoactivationRatio_OneHoppingRate = CoactivationRatio_OneLimb( RowIndices_OneHoppingRate, :);


                        %Take the mean of all columns of AllTS_CoactivationRatio, EXCEPT for the 2nd and 5th
                        %columns - these contain the participant ID and  the hop number
                        AllTS_CoactivationRatio_GroupMeansPerRate( RowtoFill_CoactivationRatio_GroupMeans, 1 : size( AllTS_CoactivationRatio, 2 ) ) = mean( CoactivationRatio_OneHoppingRate, 1, 'omitnan' );
                        

                        %For loop to fill in the SD column. Only take standard deviation for Column 7+
                        for z = 1 : numel( ColumntoFill_SD_GroupMeans )

                            %Find the standard deviation of the 6th through 28th columns of
                            %AllTS_CoactivationRatio. These columns contain the data
                            AllTS_CoactivationRatio_GroupMeansPerRate( RowtoFill_CoactivationRatio_GroupMeans, ColumntoFill_SD_GroupMeans( z ) ) = std( CoactivationRatio_OneHoppingRate( :, ColumntoFill_SD_ParticipantMeans( z ) - 87 ), 1, 'omitnan' );

                        end
                        

                        %Add 1 to RowtoFill_CoactivationRatio_GroupMeans so that the next loop fills
                        %in the next row of AllTS_CoactivationRatio_GroupMeansPerRate
                        RowtoFill_CoactivationRatio_GroupMeans = RowtoFill_CoactivationRatio_GroupMeans + 1;
                        
                        
                        
                        
                        
%%  END B For Loop - Hopping Rate                        
                    end
                        
%% END A For Loop - Limb ID                    
            end


%% END K For Loop - Group List        
    end
    
%% END J For Loop    
end



%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 8',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end









%% SECTION 9 - Create and Export Tbles


%Want to clear the errors for the new section
lasterror = [];


%Create vector of variable names - these will become the column headers for the
%AllTS_CoactivationRatio matrix when converted to a Tble
VariableNames_NoMeans = {' Group_ID ', ' Participant_ID ', 'Limb_ID' , ' Trial_ID ', ' Hop_ID ', 'HoppingRate_ID'...
    'MedGas_iEMG_EntireHopCycle', 'GasLat_iEMG_EntireHopCycle', 'Sol_iEMG_EntireHopCycle', 'PL_iEMG_EntireHopCycle', 'TA_iEMG_EntireHopCycle',...
                                    'MedGas_iEMG_ContactPhase', 'GasLat_iEMG_ContactPhase', 'Sol_iEMG_ContactPhase', 'PL_iEMG_ContactPhase', 'TA_iEMG_ContactPhase',...
                                    'MedGas_iEMG_BrakingPhase', 'GasLat_iEMG_BrakingPhase', 'Sol_iEMG_BrakingPhase', 'PL_iEMG_BrakingPhase', 'TA_iEMG_BrakingPhase',...
                                    'MedGas_iEMG_PropulsionPhase', 'GasLat_iEMG_PropulsionPhase', 'Sol_iEMG_PropulsionPhase', 'PL_iEMG_PropulsionPhase', 'TA_iEMG_PropulsionPhase',...         
        ' AllTSContributiontoPFActivity_EntireHopCycle ', ' MedGasSolContributiontoPFActivity_EntireHopCycle ', 'GastrocnemiiContributiontoPFActivity_EntireHopCycle', 'SolContributiontoPFActivity_EntireHopCycle',...
            'SolContributiontoTSActivity_EntireHopCycle', ' TAvsAllPF_CoactivationRatio_EntireHopCycle ', ' TAvsAllbutLGas_CoactivationRatio_EntireHopCycle ',...
        ' AllTSContributiontoPFActivity_FlightPhase ', ' MedGasSolContributiontoPFActivity_FlightPhase ', ' TAvsAllPF_CoactivationRatio_FlightPhase ', ' TAvsAllbutLGas_CoactivationRatio_FlightPhase ',...
        ' AllTSContributiontoPFActivity_ContactPhase ', ' MedGasSolContributiontoPFActivity_ContactPhase ', 'GastrocnemiiContributiontoPFActivity_ContactPhase', 'SolContributiontoPFActivity_ContactPhase',...
         'MedGasContributiontoTSActivation_ContactPhase', 'GastrocnemiiContributiontoTSActivtion_ContactPhase',...
            'SolContributiontoTSActivity_ContactPhase', ' TAvsAllPF_CoactivationRatio_ContactPhase ', ' TAvsAllbutLGas_CoactivationRatio_ContactPhase ', 'PFActivationRatio_HopvsMSLVJ_ContactPhase'...
        'TSContributiontoPFActivityBrakingPhase', ' MedGasSolContributiontoPFActivity_BrakingPhase ', ' MedGasContributiontoAllTS_BrakingPhase ', ' TAvsAllPF_CoactivationRatio_BrakingPhase ', 'TwoJointTS_Contribution2AllPF_BrakingPhase',...
            'OneJointTS_Contribution2AllPF_BrakingPhase', 'SolContributiontoAllTS_BrakingPhase', 'GastrocnemiiContributiontoAllTS_BrakingPhase', 'PFActivationRatio_HopvsMSLVJ_BrakingPhase'...
        'TSContributiontoPFActivity_PropulsionPhase', ' MedGasSolContributiontoPFActivity_PropulsionPhase ', ' MedGasContributiontoAllTS_PropulsionPhase ', ' TAvsAllPF_CoactivationRatio_PropulsionPhase ', 'TwoJointTS_Contribution2AllPF_PropulsionPhase', 'OneJointTS_Contribution2AllPF_PropulsionPhase',...
            'SolContributiontoAllTS_PropulsionPhase', 'GastrocnemiiContributiontoAllTS_PropulsionPhase', 'PFActivationRatio_HopvsMSLVJ_PropulsionPhase',...
        'GasMed_AverageIntegratedEMG_BrakingPhase','GasLat_AverageIntegratedEMG_BrakingPhase','Sol_AverageIntegratedEMG_BrakingPhase',...
            'PL_AverageIntegratedEMG_BrakingPhase','TA_AverageIntegratedEMG_BrakingPhase',...
            'TSContributiontoPFActivity_BrakingPhase_Average', 'MedGasSolContributiontoPFActivity_BrakingPhase_Average','MedGasContributiontoAllTS_BrakingPhase_Average',...
            'TAvsAllPF_CoactivationRatio_BrakingPhase_Average', 'TwoJointTS_Contribution2AllPF_BrakingPhase_Average', 'OneJointTS_Contribution2AllPF_BrakingPhase_Average',...
            'SolContributiontoAllTS_BrakingPhase_Average', 'TwoJointTS_Contribution2TS_BrakingPhase_Average',...
        'GasMed_AverageIntegratedEMG_PropulsionPhase','GasLat_AverageIntegratedEMG_PropulsionPhase','Sol_AverageIntegratedEMG_PropulsionPhase',...
            'PL_AverageIntegratedEMG_PropulsionPhase','TA_AverageIntegratedEMG_PropulsionPhase',...
            'TSContributiontoPFActivity_PropulsionPhase_Average', 'MedGasSolContributiontoPFActivity_PropulsionPhase_Average','MedGasContributiontoAllTS_PropulsionPhase_Average',...
            'TAvsAllPF_CoactivationRatio_PropulsionPhase_Average', 'TwoJointTS_Contribution2AllPF_PropulsionPhase_Average', 'OneJointTS_Contribution2AllPF_PropulsionPhase_Average',...
            'SolContributiontoAllTS_PropulsionPhase_Average', 'TwoJointTS_Contribution2TS_PropulsionPhase_Average',...
    'BetweenLimbTendonThickness_mm','VAS_Rating'};    
    

        
%Create vector of variable names - these will become the column headers for the
%participant and groups means versions of the coactivation ratio matrix when converted to a Tble
VariableNames_Means = {' Group_ID ', ' Participant_ID ', 'Limb_ID' , ' Trial_ID ', ' Hop_ID ', 'HoppingRate_ID'...
    'Mean_MedGas_iEMG_EntireHopCycle', 'Mean_GasLat_iEMG_EntireHopCycle', 'Mean_Sol_iEMG_EntireHopCycle', 'Mean_PL_iEMG_EntireHopCycle', 'Mean_TA_iEMG_EntireHopCycle',...
                    'Mean_MedGas_iEMG_ContactPhase', 'Mean_GasLat_iEMG_ContactPhase', 'Mean_Sol_iEMG_ContactPhase', 'Mean_PL_iEMG_ContactPhase', 'Mean_TA_iEMG_ContactPhase',...
                    'Mean_MedGas_iEMG_BrakingPhase', 'Mean_GasLat_iEMG_BrakingPhase', 'Mean_Sol_iEMG_BrakingPhase', 'Mean_PL_iEMG_BrakingPhase', 'Mean_TA_iEMG_BrakingPhase',...
                    'Mean_MedGas_iEMG_PropulsionPhase', 'Mean_GasLat_iEMG_PropulsionPhase', 'Mean_Sol_iEMG_PropulsionPhase', 'Mean_PL_iEMG_PropulsionPhase', 'Mean_TA_iEMG_PropulsionPhase',...         
    ' Mean_AllTSContributiontoPFActivity_EntireHopCycle ', ' Mean_MedGasSolContributiontoPFActivity_EntireHopCycle ', 'Mean_GastrocnemiiContributiontoPFActivity_EntireHopCycle', 'Mean_SolContributiontoPFActivity_EntireHopCycle',...
                'Mean_SolContributiontoTSActivity_EntireHopCycle', ' Mean_TAvsAllPF_CoactivationRatio_EntireHopCycle ', ' Mean_TAvsAllbutLGas_CoactivationRatio_EntireHopCycle ',...
    ' Mean_AllTSContributiontoPFActivity_FlightPhase ', ' Mean_MedGasSolContributiontoPFActivity_FlightPhase ', ' Mean_TAvsAllPF_CoactivationRatio_FlightPhase ', ' Mean_TAvsAllbutLGas_CoactivationRatio_FlightPhase ',...
                ' Mean_AllTSContributiontoPFActivity_ContactPhase ', ' Mean_MedGasSolContributiontoPFActivity_ContactPhase ', 'Mean_GastrocnemiiContributiontoPFActivity_ContactPhase', 'Mean_SolContributiontoPFActivity_ContactPhase',...
     'Mean_MedGasContributiontoTSActivation_ContactPhase', 'Mean_GastrocnemiiContributiontoTSActivtion_ContactPhase', 'Mean_SolContributiontoTSActivity_ContactPhase',...
                ' Mean_TAvsAllPF_CoactivationRatio_ContactPhase ', ' Mean_TAvsAllbutLGas_CoactivationRatio_ContactPhase ', 'Mean_PFActivationRatio_HopvsMSLVJ_ContactPhase',...
    'Mean_TSContributiontoPFActivityBrakingPhase', ' Mean_MedGasSolContributiontoPFActivity_BrakingPhase ', ' Mean_MedGasContributiontoAllTS_BrakingPhase ', ' Mean_TAvsAllPF_CoactivationRatio_BrakingPhase ',...
                'Mean_TwoJointTS_Contribution2AllPF_BrakingPhase', 'Mean_OneJointTS_Contribution2AllPF_BrakingPhase', 'Mean_SolContributiontoAllTS_BrakingPhase', 'Mean_GastrocnemiiContributiontoAllTS_BrakingPhase', 'Mean_PFActivationRatio_HopvsMSLVJ_BrakingPhase',...
    'Mean_TSContributiontoPFActivity_PropulsionPhase', ' Mean_MedGasSolContributiontoPFActivity_PropulsionPhase ', ' Mean_MedGasContributiontoAllTS_PropulsionPhase ', ' Mean_TAvsAllPF_CoactivationRatio_PropulsionPhase ',...
                'Mean_TwoJointTS_Contribution2AllPF_PropulsionPhase', 'Mean_OneJointTS_Contribution2AllPF_PropulsionPhase', 'Mean_SolContributiontoAllTS_PropulsionPhase', 'Mean_GastrocnemiiContributiontoAllTS_PropulsionPhase', 'Mean_PFActivationRatio_HopvsMSLVJ_PropulsionPhase',...
    'Mean_GasMed_AverageIntegratedEMG_BrakingPhase','Mean_GasLat_AverageIntegratedEMG_BrakingPhase','Mean_Sol_AverageIntegratedEMG_BrakingPhase',...
        'Mean_PL_AverageIntegratedEMG_BrakingPhase','Mean_TA_AverageIntegratedEMG_BrakingPhase',...
        'Mean_TSContributiontoPFActivity_BrakingPhase_Average', 'Mean_MedGasSolContributiontoPFActivity_BrakingPhase_Average','Mean_MedGasContributiontoAllTS_BrakingPhase_Average',...
        'Mean_TAvsAllPF_CoactivationRatio_BrakingPhase_Average', 'Mean_TwoJointTS_Contribution2AllPF_BrakingPhase_Average', 'Mean_OneJointTS_Contribution2AllPF_BrakingPhase_Average',...
        'Mean_SolContributiontoAllTS_BrakingPhase_Average', 'Mean_TwoJointTS_Contribution2TS_BrakingPhase_Average',...
    'Mean_GasMed_AverageIntegratedEMG_PropulsionPhase','Mean_GasLat_AverageIntegratedEMG_PropulsionPhase','Mean_Sol_AverageIntegratedEMG_PropulsionPhase',...
        'Mean_PL_AverageIntegratedEMG_PropulsionPhase','Mean_TA_AverageIntegratedEMG_PropulsionPhase',...
        'Mean_TSContributiontoPFActivity_PropulsionPhase_Average', 'Mean_MedGasSolContributiontoPFActivity_PropulsionPhase_Average','Mean_MedGasContributiontoAllTS_PropulsionPhase_Average',...
        'Mean_TAvsAllPF_CoactivationRatio_PropulsionPhase_Average', 'Mean_TwoJointTS_Contribution2AllPF_PropulsionPhase_Average', 'Mean_OneJointTS_Contribution2AllPF_PropulsionPhase_Average',...
        'Mean_SolContributiontoAllTS_PropulsionPhase_Average', 'Mean_TwoJointTS_Contribution2TS_PropulsionPhase_Average',...
    'Mean_BetweenLimbTendonThickness_mm', 'Mean_VAS_Rating',...
    'SD_MedGas_iEMG_EntireHopCycle', 'SD_GasLat_iEMG_EntireHopCycle', 'SD_Sol_iEMG_EntireHopCycle', 'SD_PL_iEMG_EntireHopCycle', 'SD_TA_iEMG_EntireHopCycle',...
                'SD_MedGas_iEMG_ContactPhase', 'SD_GasLat_iEMG_ContactPhase', 'SD_Sol_iEMG_ContactPhase', 'SD_PL_iEMG_ContactPhase', 'SD_TA_iEMG_ContactPhase',...
                'SD_MedGas_iEMG_BrakingPhase', 'SD_GasLat_iEMG_BrakingPhase', 'SD_Sol_iEMG_BrakingPhase', 'SD_PL_iEMG_BrakingPhase', 'SD_TA_iEMG_BrakingPhase',...
                'SD_MedGas_iEMG_PropulsionPhase', 'SD_GasLat_iEMG_PropulsionPhase', 'SD_Sol_iEMG_PropulsionPhase', 'SD_PL_iEMG_PropulsionPhase', 'SD_TA_iEMG_PropulsionPhase',...         
    ' SD_AllTSContributiontoPFActivity_EntireHopCycle ', ' SD_MedGasSolContributiontoPFActivity_EntireHopCycle ', 'SD_GastrocnemiiContributiontoPFActivity_EntireHopCycle', 'SD_SolContributiontoPFActivity_EntireHopCycle',...
            'SD_SolContributiontoTSActivity_EntireHopCycle', ' SD_TAvsAllPF_CoactivationRatio_EntireHopCycle ', ' SD_TAvsAllbutLGas_CoactivationRatio_EntireHopCycle ',...
    ' SD_AllTSContributiontoPFActivity_FlightPhase ', ' SD_MedGasSolContributiontoPFActivity_FlightPhase ', ' SD_TAvsAllPF_CoactivationRatio_FlightPhase ', ' SD_TAvsAllbutLGas_CoactivationRatio_FlightPhase ',...
    ' SD_AllTSContributiontoPFActivity_ContactPhase ', ' SD_MedGasSolContributiontoPFActivity_ContactPhase ', 'SD_GastrocnemiiContributiontoPFActivity_ContactPhase', 'SD_SolContributiontoPFActivity_ContactPhase',...
             'SD_MedGasContributiontoTSActivation_ContactPhase', 'SD_GastrocnemiiContributiontoTSActivtion_ContactPhase', 'SD_SolContributiontoTSActivity_ContactPhase',...
             ' SD_TAvsAllPF_CoactivationRatio_ContactPhase ', ' SD_TAvsAllbutLGas_CoactivationRatio_ContactPhase ', 'SD_PFActivationRatio_HopvsMSLVJ_ContactPhase'...
    'SD_TSContributiontoPFActivityBrakingPhase', ' SD_MedGasSolContributiontoPFActivity_BrakingPhase ', ' SD_MedGasContributiontoAllTS_BrakingPhase ', ' SD_TAvsAllPF_CoactivationRatio_BrakingPhase ',...
            'SD_TwoJointTS_Contribution2AllPF_BrakingPhase', 'SD_OneJointTS_Contribution2AllPF_BrakingPhase', 'SD_SolContributiontoAllTS_BrakingPhase', 'SD_GastrocnemiiContributiontoAllTS_BrakingPhase', 'SD_PFActivationRatio_HopvsMSLVJ_BrakingPhase'...
    'SD_TSContributiontoPFActivity_PropulsionPhase', ' SD_MedGasSolContributiontoPFActivity_PropulsionPhase ', ' SD_MedGasContributiontoAllTS_PropulsionPhase ', ' SD_TAvsAllPF_CoactivationRatio_PropulsionPhase ',...
            'SD_TwoJointTS_Contribution2AllPF_PropulsionPhase', 'SD_OneJointTS_Contribution2AllPF_PropulsionPhase', 'SD_SolContributiontoAllTS_PropulsionPhase', 'SD_GastrocnemiiContributiontoAllTS_PropulsionPhase', 'SD_PFActivationRatio_HopvsMSLVJ_PropulsionPhase',...
    'SD_GasMed_AverageIntegratedEMG_BrakingPhase','SD_GasLat_AverageIntegratedEMG_BrakingPhase','SD_Sol_AverageIntegratedEMG_BrakingPhase',...
        'SD_PL_AverageIntegratedEMG_BrakingPhase','SD_TA_AverageIntegratedEMG_BrakingPhase',...
        'SD_TSContributiontoPFActivity_BrakingPhase_Average', 'SD_MedGasSolContributiontoPFActivity_BrakingPhase_Average','SD_MedGasContributiontoAllTS_BrakingPhase_Average',...
        'SD_TAvsAllPF_CoactivationRatio_BrakingPhase_Average', 'SD_TwoJointTS_Contribution2AllPF_BrakingPhase_Average', 'SD_OneJointTS_Contribution2AllPF_BrakingPhase_Average',...
        'SD_SolContributiontoAllTS_BrakingPhase_Average', 'SD_TwoJointTS_Contribution2TS_BrakingPhase_Average',...
    'SD_GasMed_AverageIntegratedEMG_PropulsionPhase','SD_GasLat_AverageIntegratedEMG_PropulsionPhase','SD_Sol_AverageIntegratedEMG_PropulsionPhase',...
        'SD_PL_AverageIntegratedEMG_PropulsionPhase','SD_TA_AverageIntegratedEMG_PropulsionPhase',...
        'SD_TSContributiontoPFActivity_PropulsionPhase_Average', 'SD_MedGasSolContributiontoPFActivity_PropulsionPhase_Average','SD_MedGasContributiontoAllTS_PropulsionPhase_Average',...
        'SD_TAvsAllPF_CoactivationRatio_PropulsionPhase_Average', 'SD_TwoJointTS_Contribution2AllPF_PropulsionPhase_Average', 'SD_OneJointTS_Contribution2AllPF_PropulsionPhase_Average',...
        'SD_SolContributiontoAllTS_PropulsionPhase_Average', 'SD_TwoJointTS_Contribution2TS_PropulsionPhase_Average',...
    'SD_BetweenLimbTendonThickness_mm', 'SD_VAS_Rating' };   
    
    
%Use the array2table function to convert AllTS_CoactivationRatio into a Tble with column
%headers
HoppingCoactivationRatio_Tble = array2table( AllTS_CoactivationRatio, 'VariableNames', VariableNames_NoMeans );


%Save coactivation Tble in the data structure
David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure, 'Post_Quals','AllGroups', 'HoppingCoactivationRatio_Tble',...
                                HoppingCoactivationRatio_Tble);

%Save coactivation matrix (NOT a table) in the data structure
David_DissertationEMGDataStructure = setfield(David_DissertationEMGDataStructure, 'Post_Quals','AllGroups', 'HoppingCoactivationRatio_Matrix',...
                                AllTS_CoactivationRatio);



%Use the array2table function to convert AllTS_CoactivationRatio_ParticipantMeansPerRate into a Tble with column
%headers    
HoppingCoactivationRatio_ParticipantMeansPerRate_Tble = array2table( AllTS_CoactivationRatio_ParticipantMeansPerRate, 'VariableNames', VariableNames_Means );

%Use the array2table function to convert AllTS_CoactivationRatio_GroupMeansPerRate into a Tble with column
%headers    
HoppingCoactivationRatio_GroupMeansPerRate_Tble = array2table( AllTS_CoactivationRatio_GroupMeansPerRate, 'VariableNames', VariableNames_Means );







%Export HoppingCoactivationRatio_Tble as a .xlsx file
writetable( HoppingCoactivationRatio_Tble, 'PostQuals_HoppingCoactivationRatio.xlsx' );

%Export HoppingCoactivationRatio_ParticipantMeansPerRate_Tble as a .xlsx file    
writetable( HoppingCoactivationRatio_ParticipantMeansPerRate_Tble, 'PostQuals_HoppingCoactivationRatio_ParticipantMeansPerRate.xlsx'  );

%Export HoppingCoactivationRatio_GroupMeansPerRate_Tble as a .xlsx file    
writetable( HoppingCoactivationRatio_GroupMeansPerRate_Tble, 'PostQuals_HoppingCoactivationRatio_GroupMeansPerRate.xlsx' );
    
    



clearvars -except David_DissertationEMGDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList DataCategories_HoppingKinematicsKinetics ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass CreateStruct

clc
    
    
    
    %Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 9',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end