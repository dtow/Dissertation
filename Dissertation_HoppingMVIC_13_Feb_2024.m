%% SECTION 1 - Load Data Structure
load( 'Post-Quals Data/Data Structure/Current Version/David_DissertationDataStructure_17_Apr_2024.mat');


%Need to create a data structure for use in creating a dialog box stating there are no errors in
%this section, if all code was run
CreateStruct.Interpreter = 'tex';
CreateStruct.Resize = 'on';
CreateStruct.WindowStyle = 'modal';

%Want to clear the errors for the new section
lasterror = [];

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

%Lines 33 - 43 will help us index into different parts of the data structure
%First field within data structure = data for quals versus for remainder of dissertation
QualvsPostQualData = {'Post_Quals'};
%Second field = group list
GroupList = {'ATx', 'Control'}; 
%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74', 'ATx65',...
    'ATx14' };
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC44', 'HC48', 'HC65' };

%4th field = data type
DataCategories = {'HoppingEMG'};
%5th field = limb ID

EMGID = {'MVIC'};

%6th field = trial number
MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11','Trial12'};
HoppingTrialNumber = {'Trial1'};

%Create a vector containing the names for the actual MVIC tasks
MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
    'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
    'VJump'; 'VJump'; 'VJump'; 'VJump' };

%Load the Mass data from the data structure
MassLog = David_DissertationDataStructure.Post_Quals.AllGroups.MassLog;

%String for labeling y-axis of non-normalized EMG
RawHoppingUnits_string = 'Voltage (mV)';


%Specify sampling rates for GRF, EMG, kinematics/kinetics
GRFSampHz = 1500;
EMGSampHz = 1500;
MoCapSampHz = 250;


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 2',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end







%% SECTION 3 - Process MVIC
  
 
%Want to clear the errors for the new section
lasterror = [];
  

            
%Create a prompt so we can manually enter the group of interest
ShowAnyPlotsPrompt =  'Show Any Plots ?' ;

%Use inputdlg function to create a dialogue box for the prompt created above.
%First arg is prompt, 2nd is title
ShowAnyPlots_Cell = inputdlg( [ '\fontsize{15}' ShowAnyPlotsPrompt ], 'Show Any Plots?', [1 150], {'No'} ,CreateStruct);


% BEGIN L For Loop 
for l = 1 : numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});

    
%% BEGIN M For Loop - Group List      
    for m = 2% : numel(GroupList)
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure,GroupList{m});
        
        
        
        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{m}, 'ATx' )
            
            %Set the participant list to consist of the ATx participants
            ParticipantList = ATxParticipantList;

            %Set the limb ID list to consist of the involved and non-involved limbs
            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            %Set the participant list to consist of the control participants
            ParticipantList = ControlParticipantList;
            
            %Set the limb ID list to consist of the left and right limbs
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        

        
        
%% BEGIN N For Loop - Participant List        
        for n = 19 : 20%numel(ParticipantList)
            
            
            if strcmp( cell2mat( ShowAnyPlots_Cell ), 'Yes' ) || strcmp( cell2mat( ShowAnyPlots_Cell ), 'Y' )
                
                %Create a prompt so we can manually enter the group of interest
                ShowPlotsPrompt = [ 'Show Plots for  ', ParticipantList{n}, '?' ];
    
                %Use inputdlg function to create a dialogue box for the prompt created above.
                %First arg is prompt, 2nd is title
                ShowPlots_Cell = inputdlg( [ '\fontsize{15}' ShowPlotsPrompt ], 'Show Plots?', [1 150], {'No'} ,CreateStruct);

            else
                    
                ShowPlots_Cell = {'No'};

            end

 


            %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
            DataCategoriesDataStructure = getfield(ParticipantListDataStructure,ParticipantList{n});
            
            
            
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
                HoppingRate_ID_forTable = [ 0, 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{n}, 'ATx24'  )
                
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
                HoppingRate_ID_forTable = [ 2, 2.33 ];




            elseif strcmp( ParticipantList{n}, 'ATx19'  ) || strcmp( ParticipantList{n}, 'ATx65'  )
             
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
                HoppingRate_ID_forTable = [ 2, 2.33 ];



            elseif strcmp( ParticipantList{n}, 'ATx12'  ) || strcmp( ParticipantList{n}, 'ATx14'  ) || strcmp( ParticipantList{n}, 'ATx27'  ) || strcmp( ParticipantList{n}, 'ATx34'  ) || strcmp( ParticipantList{n}, 'ATx44'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx50'  ) || strcmp( ParticipantList{n}, 'ATx100'  )
             
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
                HoppingRate_ID_forTable = [ 0, 2, 2.33 ]; 
                
                



            elseif strcmp( ParticipantList{ n }, 'HC11'  ) || strcmp( ParticipantList{n}, 'HC42'  )
                
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
                 HoppingRate_ID_forTable = [ 2, 2.33 ];
                
                
                

            elseif strcmp( ParticipantList{ n }, 'HC17'  ) || strcmp( ParticipantList{ n }, 'HC21'  ) ||...
                    strcmp( ParticipantList{ n }, 'HC32'  ) || strcmp( ParticipantList{ n }, 'HC34'  ) || strcmp( ParticipantList{ n }, 'HC45'  ) ||...
                    strcmp( ParticipantList{ n }, 'HC48'  ) ||strcmp( ParticipantList{ n }, 'HC65'  ) || strcmp( ParticipantList{ n }, 'HC68'  )
                
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
                HoppingRate_ID_forTable = [ 0, 2, 2.33 ];


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
                 HoppingRate_ID_forTable = [ 0, 2, 2.33 ];
                
                               
            end
            
            
            
            
            
            
            
             
%% BEGIN O For Loop - Data Categories   
            for o = 1 : numel(DataCategories)
                
                %Use get field to create a new data structure containing the list of limbs. Stored under the 4th field of the structure (the list of data categories)
                ListofDataWithinHoppingEMG_DataStructure = getfield(DataCategoriesDataStructure,DataCategories{o});

                
%% Begin R For Loop - Limb ID                   
                for r = 1% : numel(LimbID)
                    

%% Set Muscle IDs for Involved vs Non-Involved Limb                    
                    
                    
                      %For ATx07, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                    if strcmp( ParticipantList{n}, 'ATx07'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx07'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                         
                     %For ATx10, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx10'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx10 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        

                    %For ATx10, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx10'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx10 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx12'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

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
                         
                         
                         

                     %For ATx17, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx17 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx17, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx17'  ) && strcmp( LimbID{r}, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                         
                         
                     %For ATx18, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx18 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx18'  ) && strcmp( LimbID{r}, 'InvolvedLimb')
                         
                         %Set the muscle ID list for ATx18 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         
                     

                         
                     %For ATx19, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx19'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         


                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx21'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                         

                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};




                    elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx27'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};





                    elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx39 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx44'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx44 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx44, Non-Involved Limb is Right Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx44'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

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



                    elseif strcmp( ParticipantList{n}, 'ATx50'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx50 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx50, Non-Involved Limb is Right Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx50'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx65'  ) && strcmp( LimbID{r}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx65 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx65, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx65'  ) && strcmp( LimbID{r}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx65 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



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
                    elseif strcmp(LimbID{r},'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the LeftLimb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                     end         
                     
                    
                     
                     
                    

%% Set Trial IDs for Each Participant

                     %Participants HP08 has MoCap sampling Hz of 150 instead of 250. Participant
                     %HP02 has MoCap sampling Hz of 300 instead of 250, and only has 8 reference
                     %contraction trials. HP09 has only 7 reference contraction trials - we only
                     %collected on one limb
                     if strcmp( ParticipantList{ n }, 'ATx08' )
                         
                         MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1','Trial3','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11','Trial12','Trial13','Trial14','Trial15'};


                     elseif strcmp( ParticipantList{ n }, 'ATx12' )
                         
                         MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1','Trial3','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11','Trial12'};


                     elseif strcmp( ParticipantList{ n }, 'ATx24' )
                         
                         MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1', 'Trial2', 'Trial3', 'Trial4', 'Trial5','Trial6','Trial7','Trial8','Trial9','Trial10'};


                     elseif strcmp( ParticipantList{ n }, 'ATx27' )
                         
                         MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11','Trial12','Trial13','Trial14'};


                     elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) || strcmp( ParticipantList{ n }, 'HC21' ) || strcmp( ParticipantList{ n }, 'HC42' )
                         
                         MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11', 'Trial12', 'Trial13' };


                     elseif strcmp( ParticipantList{ n }, 'HC12' )
                         
                         MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial11','Trial12'};

                                                  
                     elseif strcmp( ParticipantList{ n }, 'HP08' )

                        MoCapSampHz = 150;
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11','Trial12'};


                    elseif strcmp( ParticipantList{ n }, 'HP02' )

                        MoCapSampHz = 300;    
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8'};
                        

                    elseif strcmp( ParticipantList{ n }, 'HP09' )

                        MoCapSampHz = 250;    
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7'};

                    else

                        MoCapSampHz = 250;
                        
                        MVICTrialNumber = {'Trial1','Trial2','Trial3','Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10','Trial11','Trial12'};

                    end
                    
                    
                    
                    
                    %Reset/initialize the variable to hold the peak muscle activation for all 5
                    %muscles of a given limb
                    PeakMVICs = NaN(1,5);
                    PeakMVICs_NormalizeMSLVJ = NaN(1,5);

                    %Reset/initialize the variable to hold peak muscle activation from the
                    %rectified, non-bandpass filtered data
                    PeakMVICs_RectifiedNoBandpass = NaN(1,5);
 
                    %Use get field to create a new data structure containing the data for the right
                    %limb
                    MVICDataStructure = ListofDataWithinHoppingEMG_DataStructure.MVIC;

                    %Create a variable to hold the resting EMG data
                    RestingEMG = ListofDataWithinHoppingEMG_DataStructure.RestingEMG;
                
                    
                        
%% Begin Q For Loop - Muscle ID                        
                   for q = 1 : numel(MuscleID)

                     %Initalize the variable to hold the max muscle activation for every reference contraction of a given muscle  
                    PeakMVICs_MuscleQ = NaN(1,numel(MVICTrialNumber));
                    PeakMVICS_NoBandpass_MuscleQ = NaN(1,numel(MVICTrialNumber));
                    MuscleQ_Integrated_TempVec = NaN(2,1);
                    MuscleQ_BrakingPhaseIntegrated_TempVec = NaN(2,1);
                    MuscleQ_PropulsionPhaseIntegrated_TempVec = NaN(2,1);

                    %Find mean of the Qth muscle's resting EMG. 
                    MuscleQ_RestingEMGMean = mean(getfield(RestingEMG, MuscleID{q}));


                    
 %% Begin P For Loop - MVIC Trial Number                              
                        for p = 1 : numel(MVICTrialNumber)

                            %Use get field to create a new data structure containing the data for
                            %the pth MVIC trial
                            TrialNumber_Table = getfield(MVICDataStructure, MVICTrialNumber{ p } );

                            %Use get field to create a new data structure containing the data for
                            %the Qth muscle in the pth MVIC trial
                            MuscleQTrialP = getfield(TrialNumber_Table, MuscleID{q});

    %% Remove DC Offset
                            %Subtract mean of resting EMG from raw EMG to remove DC offset
                            MuscleQ_DCOffsetRemoved = MuscleQTrialP - MuscleQ_RestingEMGMean;

                            %Create a time vector to be used for the x-axis of plots
                            TimeVector = (1:numel(MuscleQ_DCOffsetRemoved))./EMGSampHz;

                            %Only show plots if we told the code to do so
                            if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                                %Plot the EMG with and without DC offset to check the quality of the
                                %removal
                                figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of DC Offset Removal ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' _ '  ' ', MVICTrialNumber{p}] )
                                X1 =  subplot(2,1,1);
                                plot(TimeVector',MuscleQTrialP,'LineWidth',2)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('Raw MVIC - with DC Offset')
    
                                subplot(2,1,2)
                                X2 = plot(TimeVector',MuscleQ_DCOffsetRemoved,'LineWidth',2);
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('Raw MVIC - DC Offset Removed')
    
                                %Link the axes so any zooming in/out in one plot changes the other plot
                                linkaxes( [ X1 X2 ], 'xy')
    
                                pause

                            end



%% Pad Data for Filtering

                            %When padding, will split data in half - pad the front with
                            %half, pad the back with half
                            HalfLengthofData_forPadding = round( numel( MuscleQ_DCOffsetRemoved ) ./ 2 );
                            
                            %Reverse the data - first value is now last, last value is now
                            %first
                            InvertedData = flip( MuscleQ_DCOffsetRemoved );
                            
                            %Divide the inverted data into halves. First half = the first
                            %half of the original data, but reversed from front to back.
                            %Same for second half
                            FirstHalfofInvertedData = InvertedData(  HalfLengthofData_forPadding : end ); 
                            SecondHalfofInvertedData = InvertedData( 1 : HalfLengthofData_forPadding ) ;

                            %Avoid any artificial noise. Subtract the first half of the inverted data from the very first value of
                            %the original data. Subtract the second half of the inverted
                            %data from the last value of the original data.
                            CorrectedFirstHalfofInvertedData = FirstHalfofInvertedData(end) - FirstHalfofInvertedData;
                            CorrectedSecondHalfofInvertedData = SecondHalfofInvertedData(1) - SecondHalfofInvertedData;
                           
                            %Add inverted data to original data
                            PaddedData = [ FirstHalfofInvertedData; MuscleQ_DCOffsetRemoved; CorrectedSecondHalfofInvertedData];
                            
                            %Will need to segment original data back out from padded data.
                            OriginalDataIndices = (HalfLengthofData_forPadding +1 ) :  (HalfLengthofData_forPadding + numel( MuscleQ_DCOffsetRemoved ) );


%% Check Padding of Data


                            %Create a time vector to be used for the x-axis of plots
                            TimeVector_PaddedData = ( 1 : numel( PaddedData ) )./EMGSampHz;

                            %Only show plots if we told the code to do so
                            if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                                %Plot the EMG with and without DC offset to check the quality of the
                                %removal
                                figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Padding of Data ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' _ '  ' ', MVICTrialNumber{p}] )
                                X1 =  subplot(2,1,1);
                                plot(TimeVector', MuscleQ_DCOffsetRemoved, 'LineWidth',2)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('DC Offset Removed - Unpadded')
    
                                subplot(2,1,2)
                                X2 = plot( TimeVector_PaddedData', PaddedData, 'LineWidth',2);
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('DC Offset Removed - Padded')
    
                                %Link the axes so any zooming in/out in one plot changes the other plot
                                linkaxes( [ X1 X2 ], 'xy')
    
                                pause

                            end



    %% Notch Filter

                            %Use a notch-filter set to filter out any 60 Hz noise from equipment
                            MuscleQ_NotchFilteredAt60Hz = BasicFilter( PaddedData, EMGSampHz,60,2,'notch');

                            %Use a notch-filter set to filter out any 50 Hz noise from equipment
                            MuscleQ_NotchFilteredAt50Hz = BasicFilter( MuscleQ_NotchFilteredAt60Hz,EMGSampHz,50,2,'notch');

                            %David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals','Control','HP02','HoppingKinematicsKinetics','IndividualHops','RightLimb',...
                                %'GasMed_MTU','BeginGroundContact_GRFIndices',LLimb_GContactBegin_FrameNumbers_GRFHz);

    %% Bandpass Filter

                            %Bandpass filter with low-pass cut off of 500 Hz and high-pass
                            %cut-off of 10 Hz, 2nd order     
                            MuscleQ_BandpassFiltered = BasicFilter( PaddedData, EMGSampHz, [30 500],2,'bandpass');


     %% Rectify EMG                       

                             %Set MuscleQ_Rectified to be the same as
                            %MuscleQ_BandPassFiltered. We will overwrite this later                           
                            MuscleQ_Rectified = MuscleQ_BandpassFiltered;

                            %Find all negative values in MuscleQ_BandpassFiltered
                            MuscleQ_NegativeValues = MuscleQ_BandpassFiltered<0;

                            %Multiply all negative values in MuscleQ_Rectified by -1 so that
                            %all values are now positive
                            MuscleQ_Rectified(MuscleQ_NegativeValues) = MuscleQ_Rectified(MuscleQ_NegativeValues)*(-1);



                            %Rectify the EMG signal with only DC offset removed - compare with
                            %Eugene data
                            MuscleQ_Rectified_NoBandpass = MuscleQ_DCOffsetRemoved;

                            %Find all negative values in MuscleQ_NoBandpass
                            MuscleQ_NegativeValues = MuscleQ_Rectified_NoBandpass<0;

                            %Multiply all negative values in MuscleQ_Rectified_NoBandpass by -1 so that
                            %all values are now positive
                            MuscleQ_Rectified_NoBandpass(MuscleQ_NegativeValues) = MuscleQ_Rectified_NoBandpass( MuscleQ_NegativeValues )*(-1);





    %% Smooth MVIC                        

                            %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                            %Hz of 3 Hz
                            MuscleQ_Smoothed = BasicFilter_SinglePass(MuscleQ_Rectified,EMGSampHz,3.5,2,'lowpass');



%% Remove Padding

                        MuscleQ_Rectified_Padded = MuscleQ_Rectified;
                        MuscleQ_Smoothed_Padded = MuscleQ_Smoothed;

                        MuscleQ_NotchFilteredAt60Hz = MuscleQ_NotchFilteredAt60Hz( OriginalDataIndices );
                        MuscleQ_NotchFilteredAt50Hz = MuscleQ_NotchFilteredAt50Hz( OriginalDataIndices );
                        MuscleQ_BandpassFiltered = MuscleQ_BandpassFiltered( OriginalDataIndices );
                        MuscleQ_Smoothed = MuscleQ_Smoothed( OriginalDataIndices );
                        MuscleQ_Rectified = MuscleQ_Rectified( OriginalDataIndices );


%% Check Removal of Padding


                        %Only show plots if we told the code to do so
                        if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                            %Plot the EMG before and after smoothing to check the quality of the
                            %smoothjing
                            figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Padding Removal ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' ', MVICTrialNumber{p}])

                            subplot( 3, 1, 1 )
                            plot(TimeVector_PaddedData',MuscleQ_Rectified_Padded,'LineWidth',1.5)
                            hold on
                            plot(TimeVector_PaddedData',MuscleQ_Smoothed_Padded,'LineWidth',4)
                            xlabel('Time (s)')
                            xticks( 0 : 2 : TimeVector_PaddedData( numel( TimeVector_PaddedData ) ) )
                            ylabel( RawHoppingUnits_string )
                            title(['Padded and Smoothed Data ', ParticipantList{n}, ' ', LimbID{r}, ' ', MVICTrialNumber{p} ] )
                            legend('MVIC Rectified','MVIC Smoothed');
                            hold off

                            subplot( 3, 1, 2 )
                            plot(TimeVector', MuscleQ_Rectified,'LineWidth',1.5)
                            hold on
                            plot(TimeVector', MuscleQ_Smoothed,'LineWidth',4)
                            xlabel('Time (s)')
                            xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                            ylabel( RawHoppingUnits_string )
                            title(['Rectified/Smoothed Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{r}, ' ', MVICTrialNumber{p} ] )
                            legend('MVIC Rectified','MVIC Smoothed');
                            hold off

                            subplot( 3, 1, 3 )
                            plot(TimeVector', MuscleQ_BandpassFiltered,'LineWidth',1.5)
                            xlabel('Time (s)')
                            xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                            ylabel( RawHoppingUnits_string )
                            title(['Bandpassed Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{r}, ' ', MVICTrialNumber{p} ] )
                            hold off


                            pause

                        end


%% Plot Filtered Data


                            %Only show plots if we told the code to do so
                            if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                                %Plot the EMG before and after  filtering to check the quality of the
                                %filtering
                                figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Filtering ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' ', MVICTrialNumber{p}])
                                X1 = subplot(4,1,1);
                                plot( TimeVector', MuscleQ_DCOffsetRemoved, 'LineWidth', 2)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('Raw MVIC - with DC Offset')
    
                                X2 = subplot(4,1,2);
                                plot( TimeVector', MuscleQ_NotchFilteredAt60Hz, 'LineWidth', 2 )
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('MVIC Notch Filtered @ 60 Hz')
    
                                X3 = subplot(4,1,3);
                                plot( TimeVector', MuscleQ_NotchFilteredAt50Hz, 'LineWidth',2)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('MVIC Notch Filtered @ 50 Hz')
    
                               X4 =  subplot(4,1,4);
                                plot( TimeVector',MuscleQ_BandpassFiltered,'LineWidth',2)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('MVIC Bandpass Filtered')
    
                                %Link the axes so any zooming in/out in one plot changes the other plot
                                linkaxes( [X1 X2 X3 X4], 'xy')
    
                                pause

                            end


%% Plot Rectified Data                            



                            %Only show plots if we told the code to do so
                            if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                                %Plot the EMG before and after rectification to check the quality of the
                                %rectification
                                figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Rectification ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' ', MVICTrialNumber{p}])
                                X1 = subplot(2,1,1);
                                plot(TimeVector',MuscleQ_BandpassFiltered,'LineWidth',2)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('MVIC Bandpass Filtered')
    
                                subplot(2,1,2)
                                X2 = plot(TimeVector',MuscleQ_Rectified,'LineWidth',2);
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title('MVIC Rectified')
    
                                %Link the axes so any zooming in/out in one plot changes the other plot
                                linkaxes( [ X1 X2 ], 'xy')
    
                                pause

                            end



%% View Smoothed Data

                            %Only show plots if we told the code to do so
                            if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                                %Plot the EMG before and after smoothing to check the quality of the
                                %smoothjing
                                figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Smoothing ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' ', MVICTrialNumber{p}])
                                plot(TimeVector', MuscleQ_Rectified,'LineWidth',1.5)
                                hold on
                                plot(TimeVector', MuscleQ_Smoothed,'LineWidth',4)
                                xlabel('Time (s)')
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                ylabel( RawHoppingUnits_string )
                                title(['Check Quality of Smoothing ', ParticipantList{n}, ' ', LimbID{r}, ' ', MVICTrialNumber{p} ] )
                                legend('MVIC Rectified','MVIC Smoothed');
                                hold off
    
                                pause

                            end




    %% Find Peak MVIC - Clip Trial If Needed                        

                            %Only add code here if we need to clip a trial due to some odd noise
                           %For ATx19, Involved Limb, RSoleus, Trial 12, there is an odd spike that was not 100% diminished by filtering and smoothing. This does not seem physiological, so look for max values only BEFORE this spike occurs     
                            if strcmp( ParticipantList{ n }, 'ATx08' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( (3.2*EMGSampHz) : (4.66*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (3.2*EMGSampHz) : (4.66*EMGSampHz) ) ) ); 


                            elseif strcmp( ParticipantList{ n }, 'ATx08' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial14' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( (3*EMGSampHz) : (4.2*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (3*EMGSampHz) : (4.2*EMGSampHz) ) ) );
                        

                            elseif strcmp( ParticipantList{n}, 'ATx12') && strcmp (LimbID{r}, 'InvolvedLimb') && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( (5.6*EMGSampHz) : (6.95*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (5.6*EMGSampHz) : (6.95*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{n}, 'ATx12') && strcmp (LimbID{r}, 'InvolvedLimb') && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( (4.94*EMGSampHz) : (6.14*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (4.94*EMGSampHz) : (6.14*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{n}, 'ATx19') && strcmp (LimbID{r}, 'InvolvedLimb') && strcmp( MuscleID{q}, 'RSol' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 1 : 18791 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : 18791 ) );


                            elseif strcmp( ParticipantList{n}, 'ATx24') && strcmp (LimbID{r}, 'InvolvedLimb') && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6.01*EMGSampHz) : ( 7.1*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6.01*EMGSampHz) : ( 7.1*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{n}, 'ATx25') && strcmp (LimbID{r}, 'NonInvolvedLimb') && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 5158 : 7789 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 5158 : 7789 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx27' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 5.25*EMGSampHz) : ( 6.2*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 5.25*EMGSampHz) : ( 6.2*EMGSampHz) ) ) );
                            

                            elseif strcmp( ParticipantList{ n }, 'ATx27' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial14' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( (4.75*EMGSampHz) : ( 5.94*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (4.75*EMGSampHz) : ( 5.94*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx27' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 5.79*EMGSampHz) : ( 6.79*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 5.79*EMGSampHz) : ( 6.79*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx34' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 3.8*EMGSampHz) : ( 4.8*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 3.8*EMGSampHz) : ( 4.8*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx34' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 4.13*EMGSampHz) : ( 5.31*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 4.13*EMGSampHz) : ( 5.31*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial1' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 7.094*EMGSampHz)  : numel( MuscleQ_Smoothed ) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 7.094*EMGSampHz)  : numel( MuscleQ_Smoothed ) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial3' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 10243  : numel( MuscleQ_Smoothed ) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 10243  : numel( MuscleQ_Smoothed ) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial7' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : ( 12.74*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : ( 12.74*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 6*EMGSampHz) : ( 8.17*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 6*EMGSampHz) : ( 8.17*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 5.86*EMGSampHz) : ( 6.89*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 5.86*EMGSampHz) : ( 6.89*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial13' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 4.86*EMGSampHz) : ( 6.08*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 4.86*EMGSampHz) : ( 6.08*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36_Day1_7Jan2024' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial8' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : ( 14.72*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : ( 14.72*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx36' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( 7.15*EMGSampHz) : numel( MuscleQ_Smoothed ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( 7.15*EMGSampHz) : numel( MuscleQ_Smoothed ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx36' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 2.5*EMGSampHz) : ( 3.685*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 2.5*EMGSampHz) : ( 3.685*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx36' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 2.66*EMGSampHz) : ( 4.36*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 2.66*EMGSampHz) : ( 4.36*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx36' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 2.517*EMGSampHz) : ( 4.8*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 2.517*EMGSampHz) : ( 4.8*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx36' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 3.31*EMGSampHz) : ( 4.73*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 3.31*EMGSampHz) : ( 4.73*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx38' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' ) && strcmp( MuscleID{q}, 'RPL' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 5.53*EMGSampHz) : ( numel(MuscleQ_Smoothed) ) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 5.53*EMGSampHz) : ( numel(MuscleQ_Smoothed) ) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx39' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial5' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 18.322*EMGSampHz ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 18.322*EMGSampHz ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx39' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial7' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 19.068*EMGSampHz ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 19.068*EMGSampHz ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx39' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 30.751*EMGSampHz) : ( 34*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 30.751*EMGSampHz) : ( 34*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx39' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 12.51*EMGSampHz) : ( 14.271*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 12.51*EMGSampHz) : ( 14.271*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx39' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.397*EMGSampHz) : ( 9.608*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.397*EMGSampHz) : ( 9.608*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx39' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 15.738*EMGSampHz) : ( 17.56*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 15.738*EMGSampHz) : ( 17.56*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx44' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 9.7*EMGSampHz) : ( 11.6*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 9.7*EMGSampHz) : ( 11.6*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx44' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.5*EMGSampHz) : ( 11.5*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.5*EMGSampHz) : ( 11.5*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx44' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 17.5*EMGSampHz) : ( 20.03*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 17.5*EMGSampHz) : ( 20.03*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx44' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6.3*EMGSampHz) : ( 7.61*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6.3*EMGSampHz) : ( 7.61*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx49' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial5' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 16390 : 25923 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 16390 : 25923 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx49' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 15896 : 25939 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 15896 : 25939 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx49' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 44091 : 45895 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 44091 : 45895 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx49' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 36612 : 47342 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 36612 : 47342 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx49' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 12950 : 16489 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 12950 : 16489 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx49' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 64203 : 66847 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 64203 : 66847 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx50' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial8' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : ( 12.7*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : ( 12.7*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx50' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 9*EMGSampHz) : ( 11.43*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 9*EMGSampHz) : ( 11.43*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx50' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 7.5*EMGSampHz) : ( 10*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 7.5*EMGSampHz) : ( 10*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx50' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 15700 : 18600 ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 15700 : 18600 ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx50' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 8900 : 11900 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 8900 : 11900 ) );


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial5' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 17.211*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 17.211*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 13.68*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 13.68*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial7' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 13.7*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 13.7*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial8' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 14.391*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 14.391*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( 11.4*EMGSampHz) : round( 14*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( 11.4*EMGSampHz) : round( 14*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( 7.8*EMGSampHz) : round( 9.7*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( 7.8*EMGSampHz) : round( 9.7*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( 12.298*EMGSampHz ) : round( 15.73*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( 12.298*EMGSampHz ) : round( 15.73*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx65' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( 10.45*EMGSampHz) : round( 14.02*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( 10.45*EMGSampHz) : round( 14.02*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx74' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 13*EMGSampHz) : ( 14.5*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 13*EMGSampHz) : ( 14.5*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx74' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 12.87*EMGSampHz) : ( 15*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 12.87*EMGSampHz) : ( 15*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx74' ) && strcmp( LimbID{ r }, 'NonInvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 9.8*EMGSampHz) : ( 11.9*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 9.8*EMGSampHz) : ( 11.9*EMGSampHz) ) ) ;


                            elseif strcmp( ParticipantList{ n }, 'ATx74' ) && strcmp( LimbID{ r }, 'InvolvedLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 8.9*EMGSampHz) : ( 10.25*EMGSampHz) ) ) ;

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 8.9*EMGSampHz) : ( 10.25*EMGSampHz) ) ) ;

                                
                            %For HC01, LeftLimb, LSoleus, Trial 11, there is a burst of activity after the end of the single leg vertical jump. Only look for max values BEFORE this burst of activity    
                            elseif strcmp( ParticipantList{n}, 'HC01') && strcmp (LimbID{r}, 'LeftLimb') && strcmp( MuscleID{q}, 'LSol' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 1 : 34146 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : 34146 ) );
                                
                                
                            %For HC01, Right Limb, RTA, Trial 4 (TA MVIC), there is an odd spike
                            %before the MVIC burst. Only look for max values AFTER this odd spike
                            elseif strcmp( ParticipantList{n}, 'HC01') && strcmp (LimbID{r}, 'RightLimb') && strcmp( MuscleID{q}, 'RTA' ) && strcmp( MVICTrialNumber{p}, 'Trial4' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 13252 : length( MuscleQ_Smoothed ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 13252 : length( MuscleQ_Smoothed ) ) ); 

                                
                            %For HC01, LeftLimb, LSoleus, Trial 11, there is a burst of activity after the end of the single leg vertical jump. Only look for max values BEFORE this burst of activity    
                            elseif strcmp( ParticipantList{n}, 'HC08') && strcmp (LimbID{r}, 'LeftLimb') && strcmp( MVICTrialNumber{p}, 'Trial6' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 1 :round( 18.2*EMGSampHz ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 :round( 18.2*EMGSampHz ) ) ); 

                                
                            %For HC01, LeftLimb, LSoleus, Trial 11, there is a burst of activity after the end of the single leg vertical jump. Only look for max values BEFORE this burst of activity    
                            elseif strcmp( ParticipantList{n}, 'HC08') && strcmp (LimbID{r}, 'LeftLimb') && strcmp( MVICTrialNumber{p}, 'Trial8' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 1 :round( 15.5*EMGSampHz ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 :round( 15.5*EMGSampHz ) ) );

                                
                            %For HC12, Right Limb, RTA, Trial 12 (SLVJ), there is a burst of activity AFTER landing should have ended.
                            % Only look for max values BEFORE this
                            elseif strcmp( ParticipantList{n}, 'HC11') && strcmp (LimbID{r}, 'LeftLimb') && strcmp( MuscleID{q}, 'LTA' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( round( (3.82*EMGSampHz) : (4.8*EMGSampHz) )  ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (3.82*EMGSampHz) : (4.8*EMGSampHz) )  ) ); 


                            %For HC12, Right Limb, RTA, Trial 12 (SLVJ), there is a burst of activity AFTER landing should have ended.
                            % Only look for max values BEFORE this
                            elseif strcmp( ParticipantList{n}, 'HC11') && strcmp (LimbID{r}, 'LeftLimb') && strcmp( MuscleID{q}, 'LTA' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( round( (5.23*EMGSampHz) : (6.3*EMGSampHz) )  ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( (5.23*EMGSampHz) : (6.3*EMGSampHz) )  ) ); 


                            %For HC12, Right Limb, RTA, Trial 12 (SLVJ), there is a burst of activity AFTER landing should have ended.
                            % Only look for max values BEFORE this
                            elseif strcmp( ParticipantList{n}, 'HC12') && strcmp (LimbID{r}, 'RightLimb') && strcmp( MuscleID{q}, 'RTA' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 1 : 10801  ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : 10801  ) );


                            elseif strcmp( ParticipantList{n}, 'HC17') && strcmp (LimbID{r}, 'RightLimb') && strcmp( MuscleID{q}, 'RTA' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 11700 : 12495 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 11700 : 12495 ) );


                            elseif strcmp( ParticipantList{ n }, 'HC18' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 4702 : 8976 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 4702 : 8976 ) );


                            elseif strcmp( ParticipantList{ n }, 'HC18' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 4415 : 7550 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 4415 : 7550 ) );


                            elseif strcmp( ParticipantList{ n }, 'HC18' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 5071 : 7831 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 5071 : 7831 ) );


                            elseif strcmp( ParticipantList{ n }, 'HC18' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 3822 : 7680 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 3822 : 7680 ) );


                            elseif strcmp( ParticipantList{ n }, 'HC19' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( round( ( 13.98*EMGSampHz) : ( 15.38*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 13.98*EMGSampHz) : ( 15.38*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC20' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6.98*EMGSampHz) : ( 8.17*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6.98*EMGSampHz) : ( 8.17*EMGSampHz) ) ) );



                            elseif strcmp( ParticipantList{ n }, 'HC21' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 9.29*EMGSampHz) : ( 10.41*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 9.29*EMGSampHz) : ( 10.41*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC21' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.11*EMGSampHz) : ( 9.49*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.11*EMGSampHz) : ( 9.49*EMGSampHz) ) ) ); 


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial4' ) && strcmp( MuscleID{q}, 'LPL' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( ( 8.8*EMGSampHz) : numel( MuscleQ_Smoothed ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( ( 8.8*EMGSampHz) : numel( MuscleQ_Smoothed ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 29.69*EMGSampHz) : ( 32.2*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 29.69*EMGSampHz) : ( 32.2*EMGSampHz) ) ) ); 


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 38.17*EMGSampHz) : ( 43.34*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 38.17*EMGSampHz) : ( 43.34*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial5' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 10.76*EMGSampHz) : numel( MuscleQ_Smoothed ) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 10.76*EMGSampHz) : numel( MuscleQ_Smoothed ) ) ) ); 


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial7' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.71*EMGSampHz) : ( 17.48*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.71*EMGSampHz) : ( 17.48*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 34.26*EMGSampHz) : ( 39*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 34.26*EMGSampHz) : ( 39*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 30.57*EMGSampHz) : ( 33.25*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 30.57*EMGSampHz) : ( 33.25*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC30' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 30.57*EMGSampHz) : ( 33.25*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 30.57*EMGSampHz) : ( 33.25*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC42' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 13.45*EMGSampHz) : ( 15.5*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 13.45*EMGSampHz) : ( 15.5*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC42' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 10.79*EMGSampHz) : ( 13.11*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 10.79*EMGSampHz) : ( 13.11*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC42' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 11.63*EMGSampHz) : ( 13.92*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 11.63*EMGSampHz) : ( 13.92*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC42' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial13' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 12*EMGSampHz) : ( 14.1*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 12*EMGSampHz) : ( 14.1*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC44' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.42*EMGSampHz) : ( 16*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.42*EMGSampHz) : ( 16*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC44' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial8' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( 1 : round( 13.5*EMGSampHz ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : round( 13.5*EMGSampHz ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC44' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 12.12*EMGSampHz) : ( 14.47*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 12.12*EMGSampHz) : ( 14.47*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC44' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 12*EMGSampHz) : ( 14.57*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 12*EMGSampHz) : ( 14.57*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC44' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.8*EMGSampHz) : ( 11.39*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.8*EMGSampHz) : ( 11.39*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC44' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.8*EMGSampHz) : ( 10.3*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.8*EMGSampHz) : ( 10.3*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial3' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( 8.39*EMGSampHz) : numel( MuscleQ_Smoothed ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( 8.39*EMGSampHz) : numel( MuscleQ_Smoothed ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial7' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 4*EMGSampHz) : ( 13.24*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 4*EMGSampHz) : ( 13.24*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial8' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 3.85*EMGSampHz) : ( 13.78*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 3.85*EMGSampHz) : ( 13.78*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 14.34*EMGSampHz) : ( 15.97*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 14.34*EMGSampHz) : ( 15.97*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.55*EMGSampHz) : ( 10.11*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.55*EMGSampHz) : ( 10.11*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 10.64*EMGSampHz) : ( 12.81*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 10.64*EMGSampHz) : ( 12.81*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC48' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.5*EMGSampHz) : ( 10.44*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.5*EMGSampHz) : ( 10.44*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC53' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 3*EMGSampHz) ) : numel( MuscleQ_Smoothed ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 3*EMGSampHz) ) : numel( MuscleQ_Smoothed ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC53' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 58.5*EMGSampHz) : ( 61.6*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 58.5*EMGSampHz) : ( 61.6*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC53' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 31.6*EMGSampHz) : ( 34.17*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 31.6*EMGSampHz) : ( 34.17*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC53' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 25.9*EMGSampHz) : ( 28.53*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 25.9*EMGSampHz) : ( 28.53*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC53' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 36.3*EMGSampHz) : ( 38.79*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 36.3*EMGSampHz) : ( 38.79*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial3' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 4.583*EMGSampHz) : ( 16.318*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 4.583*EMGSampHz) : ( 16.318*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial5' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 12.988*EMGSampHz) : ( 26.56*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 12.988*EMGSampHz) : ( 26.56*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.491*EMGSampHz) : ( 19*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.491*EMGSampHz) : ( 19*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial7' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.1*EMGSampHz) : ( 17.7*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.1*EMGSampHz) : ( 17.7*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial8' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6.525*EMGSampHz) : ( 16.38*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6.525*EMGSampHz) : ( 16.38*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 21.62*EMGSampHz) : ( 24.15*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 21.62*EMGSampHz) : ( 24.15*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 5.5*EMGSampHz) ) : numel( MuscleQ_Smoothed ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 5.5*EMGSampHz) ) : numel( MuscleQ_Smoothed ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 5.8*EMGSampHz) : ( 8.343*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 5.8*EMGSampHz) : ( 8.343*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC65' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 5*EMGSampHz) : ( 7.607*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 5*EMGSampHz) : ( 7.607*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC67' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.456*EMGSampHz) : ( 8.7*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.456*EMGSampHz) : ( 8.7*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC67' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6.73*EMGSampHz) : ( 8.55*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6.73*EMGSampHz) : ( 8.55*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC67' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.076*EMGSampHz) : ( 9*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.076*EMGSampHz) : ( 9*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC67' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 7.8*EMGSampHz) : ( 10.474*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 7.8*EMGSampHz) : ( 10.474*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC68' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial9' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.551*EMGSampHz) : ( 10.617*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.551*EMGSampHz) : ( 10.617*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC68' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial10' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6*EMGSampHz) : ( 8.216*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6*EMGSampHz) : ( 8.216*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC68' ) && strcmp( LimbID{ r }, 'RightLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial11' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 6.988*EMGSampHz) : ( 9.923*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 6.988*EMGSampHz) : ( 9.923*EMGSampHz) ) ) );


                            elseif strcmp( ParticipantList{ n }, 'HC68' ) && strcmp( LimbID{ r }, 'LeftLimb' ) && strcmp( MVICTrialNumber{p}, 'Trial12' )

                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed( round( ( 8.565*EMGSampHz) : ( 10.984*EMGSampHz) ) ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( round( ( 8.565*EMGSampHz) : ( 10.984*EMGSampHz) ) ) );

                                
                            %For HP09, LeftLimb, LTA, Trial 6 (normal SLVJ) , there is a large
                            %spike that doesn't seem physiological. Only look for max values BEFORE
                            %this spike
                            elseif strcmp( ParticipantList{n}, 'HP09') && strcmp (LimbID{r}, 'LeftLimb') && strcmp( MuscleID{q}, 'LTA' ) && strcmp( MVICTrialNumber{p}, 'Trial6' )
                                
                                PeakMVICs_MuscleQ(p) = max(MuscleQ_Smoothed( 1 : 9579 ) );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass( 1 : 9579 ) );

                                
                            %If there are no known issues in the EMG signal, find the peak MVIC using ALL data points in the signal.    
                            else
                                
                                PeakMVICs_MuscleQ(p) = max( MuscleQ_Smoothed );

                                PeakMVICS_NoBandpass_MuscleQ( p ) = max( MuscleQ_Rectified_NoBandpass );
                                
                            end
    
    

 %% View Smoothed Data with Peak MVIC Marked

                            %Only show plots if we told the code to do so
                            if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )

                                TimeofPeak = find( MuscleQ_Smoothed == PeakMVICs_MuscleQ(p) ) ./ EMGSampHz;

                                %Plot the EMG before and after smoothing to check the quality of the
                                %smoothjing
                                figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['CHECK PEAK MVIC ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{r}, ' ', MuscleID{q}, ' ', MVICTrialNumber{p}])
                                plot(TimeVector', MuscleQ_Rectified,'LineWidth',1.5)
                                hold on
                                plot(TimeVector', MuscleQ_Smoothed,'LineWidth',4)
                                plot( TimeofPeak, PeakMVICs_MuscleQ(p), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 30, 'MarkerEdgeColor', 'black' );
                                xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                xlabel('Time (s)')
                                ylabel( RawHoppingUnits_string )
                                title(['CHECK PEAK MVIC ', ParticipantList{n}, ' ', LimbID{r}, ' ', MVICTrialNumber{p} ] )
                                legend('MVIC Rectified','MVIC Smoothed');
                                hold off
    
                                pause

                            end                           


                            
                            %Close all open figures
                            close all

%% Store Processed MVIC Data in Data Structure
                            
                            %Store the raw EMG signal in the data structure
                            David_DissertationDataStructure =...
                                    setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG',LimbID{r},'MVIC',MuscleID{q},MVICTrialNumber{p},'Raw',MuscleQTrialP);
                            
                            %Store the DC offset removed EMG signal in the data structure
                            David_DissertationDataStructure =...
                                setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG',LimbID{r},'MVIC',MuscleID{q},MVICTrialNumber{p},'DC_Offset_Removed',MuscleQ_DCOffsetRemoved);

                            
                            %Store the bandpass filtered EMG signal in the data structure
                            David_DissertationDataStructure =...
                                setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG',LimbID{r},'MVIC',MuscleID{q},MVICTrialNumber{p},'BandpassFiltered',MuscleQ_BandpassFiltered);
                            
                            %Store the rectified EMG signal in the data structure
                            David_DissertationDataStructure =...
                                setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG', LimbID{r},'MVIC',MuscleID{q},MVICTrialNumber{p},'Rectified',MuscleQ_Rectified);
                            
                            %Store the smoothed EMG signal in the data structure
                            David_DissertationDataStructure =...
                                setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG', LimbID{r}, 'MVIC',MuscleID{q},MVICTrialNumber{p},'Smoothed',MuscleQ_Smoothed);


                            %Store the rectified, not bandpassed EMG signal in the data structure
                            David_DissertationDataStructure =...
                                setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG', LimbID{r},'MVIC',MuscleID{q},MVICTrialNumber{p},'Rectified_NotBandPassed', MuscleQ_Rectified_NoBandpass);


                        end % End p Loop - Hopping Trial Number


                        
%% Tell the code which MVIC Trials are for which limb                        
                        
                        %We'll use this If statement to tell the code whether we need to omit any
                        %reference contraction trials when finding the maximum muscle activation. In
                        %this first portion, we only want to use the first 10 trials for HP03 even
                        %though we collected 12 trials
                        if strcmp( ParticipantList{n}, 'ATx07' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the non-involved limb of ATx07                        
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the non-involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                 PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );

                                %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                %with Eugene's data
                                PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end


                                   
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                       
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };

                                %Find which SLVJ trial resulted in the greatest peak activation for
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                            %The indented code applies to the involved limb of ATx07
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                 
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };

                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within ATx07        
                            end
                            
                            
                            
                            
                        %The indented code applies to ATx08    
                        elseif strcmp( ParticipantList{n}, 'ATx08' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx08                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 2 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 2 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 2 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [1, 2, 5, 7, 9, 11] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx08
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 3, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 3, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 3, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 3, 4, 6, 8, 10, 12 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx08
                            end     
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        %The indented code applies to ATx10    
                        elseif strcmp( ParticipantList{n}, 'ATx10' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx10                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx10
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx10
                            end
                            
                            
                        %The indented code applies to ATx12   
                        elseif strcmp( ParticipantList{n}, 'ATx12' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC';...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx12                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 2 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 2 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 2 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 7, 9 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 3, 5 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 3, 5 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1, 2, 3, 5, 7, 9 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx12. Don't use TA MVIC -
                            %error in TA EMG
                            else

                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 9 and 11 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 8, 10 ] ) );

                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 4, 6, 8, 10 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                 PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 4, 6 ] ) );

                                %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                %with Eugene's data
                                PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 4, 6 ] ) );


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx12
                            end     
                            
                            
                            
                            
                            
                        %The indented code applies to ATx17   
                        elseif strcmp( ParticipantList{n}, 'ATx17' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                                                        
                            %The indented code applies to the non-involved limb of ATx17
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. We had to throw out one trial of the non-involved limb 
                                %single leg max vertical jump, so the last two trials for the non-involved limb are Trials 10 and 12 rather than 
                                %9 and 11. The first four are trials 1, 3, 5, 7                              
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1, 3, 5, 7, 10, 12 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                 
                            %The indented code applies to the involved limb of ATx17
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the involved limb
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                   
                                %Find which task had the highest muscle activation. We had to throw out one trial of the non-involved 
                                %limb single leg max vertical jump, so the last two trials for the involved limb are Trials 9 and 11 rather 
                                %than 10 and 12. The first four are Trials 2, 4, 6, 8              
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 2, 4, 6, 8, 9, 11 ] ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                 
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within ATx17
                            end
                            



                            
                            
                            
                        %The indented code applies to ATx18   
                        elseif strcmp( ParticipantList{n}, 'ATx18' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                                                        
                            %The indented code applies to the non-involved limb of ATx18
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the non-involved limb                              
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                 
                            %The indented code applies to the involved limb of ATx18
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the involved limb
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                   
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the involved limb                                        
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                 
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within ATx18        
                            end
                            
                            
                            
                            
                            
                        %The indented code applies to ATx19    
                        elseif strcmp( ParticipantList{n}, 'ATx19' )
                            
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                             %The indented code applies to the non-involved limb of ATx19                         
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                   
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the non-involved limb                     
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                 
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                 
                            %The indented code applies to the involved limb of ATx19
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the involved limb                               
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                            %End the if statement within ATx19        
                            end
                            
                            
                            
                            
                            
                            
                        %The indented code applies to ATx21   
                        elseif strcmp( ParticipantList{n}, 'ATx21' )
                            
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                             %The indented code applies to the non-involved limb of ATx21                         
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                   
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the non-involved limb                     
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                 
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                            %The indented code applies to the involved limb of ATx21
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the involved limb                               
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                 
                            %End the if statement within ATx21
                            end    
                            
                            
                            
                            
                            
                            
                        %The indented code applies to ATx24   
                        elseif strcmp( ParticipantList{n}, 'ATx24' )
                            
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'};
                            
                            
                             %The indented code applies to the involved limb of ATx24                         
                            if strcmp( LimbID{r}, 'InvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( 9 ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                   
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the non-involved limb                     
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 9 ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                 
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                            %The indented code applies to the non-involved limb of ATx24
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the involved limb                               
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( 10 ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 10 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                 
                            %End the if statement within ATx24
                            end    
                            
                            
                            
                            
                        %The indented code applies to ATx25   
                        elseif strcmp( ParticipantList{n}, 'ATx25' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx25                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                %For non-involved limb medial gastroc and sol, first MSLVJ trial looks odd. Only use the second trial    
                                elseif q == 1 || q == 3
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( 11 ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  1:2:12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx25
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );

                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  2:2:12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within ATx25
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx27
                        elseif strcmp( ParticipantList{n}, 'ATx27' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 'DLVJump'; 'DLVJump'
                                'SLVJump'; 'SLVJump'; 'SLVJump'; 'SLVJump' };
                            
                            %The indented code applies to the non-involved limb of ATx27                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 11, 13 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1:2:9, 10, 11, 13 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx27
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 12, 14 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 2:2:8, 9, 10, 12, 14 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx27
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx34
                        elseif strcmp( ParticipantList{n}, 'ATx34' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx34                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx34
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 9 and 11 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx34
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx36
                        elseif strcmp( ParticipantList{n}, 'ATx36' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 'SLVJump'; 'SLVJump'; 'SLVJump'; 'SLVJump' };
                            
                            %The indented code applies to the non-involved limb of ATx38                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  1 : 2 : 12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx36
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  2 : 2 : 13  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within ATx36
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx38
                        elseif strcmp( ParticipantList{n}, 'ATx38' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 'SLVJump'; 'SLVJump'; 'SLVJump'; 'SLVJump' };
                            
                            %The indented code applies to the non-involved limb of ATx38                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  1:2:12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx38
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  2:2:12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within ATx38
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx39
                        elseif strcmp( ParticipantList{n}, 'ATx39' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 'SLVJump'; 'SLVJump'; 'SLVJump'; 'SLVJump' };
                            
                            %The indented code applies to the non-involved limb of ATx39                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the non-involved limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  1 : 2 : 12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx36
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );

                                %For R PL, don't use the second MSLVJ trial - error with EMG   
                                elseif q == 4
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( 10 ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  2 : 2 : 12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within ATx36
                            end     
                            
                            
                            

                            
                        %The indented code applies to ATx41
                        elseif strcmp( ParticipantList{n}, 'ATx41' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 'SLVJump'; 'SLVJump'; 'SLVJump'; 'SLVJump' };
                            
                            %The indented code applies to the non-involved limb of ATx41                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  1:2:12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx41
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                     %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb  
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ(  2:2:12  ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx41
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx44
                        elseif strcmp( ParticipantList{n}, 'ATx44' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx44                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx44
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 10 and 12 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx44
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx49
                        elseif strcmp( ParticipantList{n}, 'ATx49' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx49                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx49
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 10 and 12 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx49
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx50
                        elseif strcmp( ParticipantList{n}, 'ATx50' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx34                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx50
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 10 and 12 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx50
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx65
                        elseif strcmp( ParticipantList{n}, 'ATx65' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx65                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1 : 2 : 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx65
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 10 and 12 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2 : 2 : 12 ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx65
                            end     
                            
                            
                            
                            
                        %The indented code applies to ATx74
                        elseif strcmp( ParticipantList{n}, 'ATx74' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                            
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            %The indented code applies to the non-involved limb of ATx74                            
                            if strcmp( LimbID{r}, 'NonInvolvedLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the non-involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                    
                                %Find which task had the highest muscle activation. Use the
                                %even-numbered tasks for the non-involved limb                                      
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 2, 4, 5, 7,9, 11 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %The indented code applies to the involved limb of ATx74
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                 %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                %Trials 10 and 12 for the involved limb  
                                 PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use the
                                %odd-numbered tasks for the involved limb                                         
                                 IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1, 3, 6, 8, 10, 12 ] ) )    );
                                 
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                                
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 

                            %End the if statement within ATx74
                            end     
                            
                            
                            
                            
                            
                            
                        %The indented code applies to HC01
                        elseif strcmp( ParticipantList{n}, 'HC01' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC01
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the right limb                                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [10,12] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                  
                                %Find which task had the highest muscle activation. Use tasks 1, 3, 6, 8, 10, 12         
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1, 3, 6, 8, 10, 12 ] ) )    );
                                  
                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                 
                             
                            %The indented code applies to the left limb of HC01
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the left limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [9,11] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. Use tasks 2, 4,
                                %5, 7, 9, 11
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [2, 4, 5, 7, 9, 11 ] ) )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                    

                            %End the if statement within HC01        
                            end
                            
                            
                          
                            
                        %The indented code applies to HC05
                        elseif strcmp( ParticipantList{n}, 'HC05' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC05
                            if strcmp( LimbID{r}, 'RightLimb' )



                                
                                %Do not want to use Trial 11 for the right peroneus longus - signal
                                %issues. Use an if statement to tell the code to only use Trial 9
                                %for the PL but use both Trial 9 and 11 for all other right limb
                                %muscles
                                if strcmp( MuscleID{q}, 'RPL' )
                                
                                    
                                    %Pick the maximum muscle activation from the single-leg vertical
                                    %jump trials. This is only Trial 9 for the Right Peroneus Longus
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( 9 ) );

                                    %Find which task had the highest muscle activation. Use all odd-numbered trials except for
                                    %Trial 11
                                    IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(   PeakMVICs_MuscleQ( 1: 2: 9 )  )    );

                                    %We will use this to display a message showing which task had the
                                    %highest muscle activation                               
                                     TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                %Use TA MVIC for TA
                                elseif strcmp( MuscleID{q}, 'RTA' )
                                    
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the right limb (except for peroneus longus)                    
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3] ) );

                                    %Find which task had the highest muscle activation, out of the
                                    %odd-numbered trials
                                    IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 )  )    );

                                    %We will use this to display a message showing which task had the
                                    %highest muscle activation                               
                                     TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );



                                    %Find which SLVJ trial resulted in the greatest peak activation for 
                                    %each muscle
                                    TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                    
                                     
                                %The indented code applies to all right limb muscles for HC05 EXCEPT for the PL     
                                else
                                    
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the right limb (except for peroneus longus)                    
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11] ) );

                                    %Find which task had the highest muscle activation, out of the
                                    %odd-numbered trials
                                    IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 )  )    );

                                    %We will use this to display a message showing which task had the
                                    %highest muscle activation                               
                                     TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                    %Find which SLVJ trial resulted in the greatest peak activation for 
                                    %each muscle
                                    TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                
                                %End the if statement for telling the code to skip Trial 11 for
                                %Right PL
                                end



                            %The indented code applies to the left limb of HC05
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the Left limb                
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation, out of the
                                %odd-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2: 2: 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                                
                            end
                                
                                
                                
                             %The indented code applies to HC06
                        elseif strcmp( ParticipantList{n}, 'HC06' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC06
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end


                                %Find which task had the highest muscle activation, out of the
                                %odd-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                             
                            %The indented code applies to the left limb of HC06
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the left limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [10, 12] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation, out of the
                                %even-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2: 2: 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                    

                            %End the if statement within HC06        
                            end
                                
                                
                                
                             %The indented code applies to HC08
                        elseif strcmp( ParticipantList{n}, 'HC08' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC08
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the right limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                %Find which task had the highest muscle activation, out of the
                                %odd-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                             
                            %The indented code applies to the left limb of HC08
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the left limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [10, 12] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation, out of the
                                %even-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2: 2: 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                    

                            %End the if statement within HC08        
                            end
                                
                                


                                
                         %The indented code applies to HC11
                        elseif strcmp( ParticipantList{n}, 'HC11' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC11
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the involved limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end


                                %Find which task had the highest muscle activation, out of the
                                %odd-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1: 2: 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );


                             
                            %The indented code applies to the left limb of
                            %HC11
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12 for the left limb
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [10, 12] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation, out of the
                                %even-numbered trials
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2: 2: 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                                    

                            %End the if statement within HC11        
                            end    
                            
                            
                            
                            
                             %The indented code applies to HC12
                        elseif strcmp( ParticipantList{n}, 'HC12' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC12
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else


                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. This only Trial 11. The other SLVJ trial didn't save.                   
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( 11 ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 2, 4, 6, 8, 11 ])  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC12
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 10. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 10 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( [ 1, 3, 5, 7, 9, 10 ] )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC12        
                            end                           
                            
                            
 
                            
                            
                             %The indented code applies to HC17
                        elseif strcmp( ParticipantList{n}, 'HC17' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC17
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. This only Trial 11. The other SLVJ trial didn't save.                   
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2:2:12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC17
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the left limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1:2:12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC17        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC18
                        elseif strcmp( ParticipantList{n}, 'HC18' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC17
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. This only Trial 11. The other SLVJ trial didn't save.                   
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end


                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2:2:12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC18
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the left limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1:2:12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC18
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC19
                        elseif strcmp( ParticipantList{n}, 'HC19' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC19
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. This only Trial 11. The other SLVJ trial didn't save.                   
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2:2:12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC19
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the left limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1:2:12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC19        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC20
                        elseif strcmp( ParticipantList{n}, 'HC20' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'   ; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC20
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the right limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC20
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 11 for the left limb            
                                     PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2: 2: 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC20        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC21
                        elseif strcmp( ParticipantList{n}, 'HC21' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC21
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. This only Trial 11. The other SLVJ trial didn't save.                   
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1, 3, 6, 8, 10, 12 ] )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC21
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 9 and 10. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 11, 13 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 7, 9 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 7, 9 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( [ 2, 4, 5, 7, 9, 11, 13 ] )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC21        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC25
                        elseif strcmp( ParticipantList{n}, 'HC25' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC21
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 9 and 10. The other SLVJ trial didn't save.                   
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 10 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 6, 8, and 11.
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 1, 3, 5, 7, 9, 10 ] )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC25
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the involved limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 11 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 11, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( [ 2, 4, 6, 8, 11, 12 ] )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC25        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC42
                        elseif strcmp( ParticipantList{n}, 'HC42' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC42
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 11, 13 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 7, 9 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 7, 9 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( [ 2, 4, 7, 9, 11, 13 ] )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC42
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3, 5 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3, 5 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3, 5 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( [ 1, 3, 5, 6, 8, 10, 12 ] )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };




                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                            %End the if statement within HC42        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC44
                        elseif strcmp( ParticipantList{n}, 'HC44' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC44
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC44
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC44        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC45
                        elseif strcmp( ParticipantList{n}, 'HC45' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC45
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC45
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC45        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC48
                        elseif strcmp( ParticipantList{n}, 'HC48' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC48
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC48
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC48        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC53
                        elseif strcmp( ParticipantList{n}, 'HC53' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC53
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR  - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC53
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC53        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC65
                        elseif strcmp( ParticipantList{n}, 'HC65' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC65
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                %For RMGas, don't use Trial11 for finding peak activation - shows
                                %excessively high spike
                                elseif q == 1

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR  - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR  - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC65
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC65        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC67
                        elseif strcmp( ParticipantList{n}, 'HC67' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC67
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR  - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 2 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC67
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 1 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC67        
                            end
                            
                            
 
                            
                            
                             %The indented code applies to HC68
                        elseif strcmp( ParticipantList{n}, 'HC68' )
                            
                            %Give a name to each reference contraction trial. This will be used to
                            %display a message saying which task showed the highest muscle
                            %activation                                                        
                            MVICTasks = { 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; 'TA MVIC'; ...
                                'SLHR'; 'SLHR'; 'SLHR'; 'SLHR'; 
                                'VJump'; 'VJump'; 'VJump'; 'VJump' };
                            
                            
                            %The indented code applies to the right limb of HC68
                            if strcmp( LimbID{r}, 'RightLimb' )


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 2 and 4 for the right limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 1, 3 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 1, 3 ] ) );


                                else

                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are Trials 11 and 13.             
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 9, 11 ] ) );

                                    %Find peak MVIC from SLHR  - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 5, 7 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed SLHR EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 5, 7 ] ) );

                                end

                                %Find which task had the highest muscle activation. The trials for
                                %the right limb are 2, 4, 7, 9, 11, 13
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max( PeakMVICs_MuscleQ( 1 : 2 : 12 )  )    );

                                %We will use this to display a message showing which task had the
                                %highest muscle activation                               
                                 TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };



                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );



                             
                            %The indented code applies to the left limb of HC68
                            else


                                %For TA, select the peak activation from the TA MVIC task
                                if q == 5

                                    %Pick the maximum muscle activation from the TA MVIC trials. These are
                                    %Trials 1, 3, 5 for the left limb                                 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );

                                    %Find peak MVIC from SLHR or TA MVIC EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 2, 4 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 2, 4 ] ) );


                                else
                                
                                    %Pick the maximum muscle activation from the single-leg vertical jump trials. These are
                                    %Trials 10 and 12. 
                                    PeakMVICs(q) = max( PeakMVICs_MuscleQ( [ 10, 12 ] ) );

                                    %Find peak MVIC from SLHR EMG - for normalizing MSLVJ EMG
                                     PeakMVICs_NormalizeMSLVJ(q) = max( PeakMVICs_MuscleQ( [ 6, 8 ] ) );
    
                                    %Find peak MVIC from rectified, non-bandpassed EMG - for comparison
                                    %with Eugene's data
                                    PeakMVICs_RectifiedNoBandpass(q) = max( PeakMVICS_NoBandpass_MuscleQ( [ 6, 8 ] ) );

                                end
                                
                                %Find which task had the highest muscle activation. The trials for
                                %the left limb are 1, 3, 5, 7, 9, and 10
                                IndexofTaskforPeakMVIC = find(  PeakMVICs_MuscleQ == max(  PeakMVICs_MuscleQ( 2 : 2 : 12 )   )    );
                                
                                %We will use this to display a message showing which task had the
                                %highest muscle activation
                                TaskforPeakMVIC = MVICTasks{ IndexofTaskforPeakMVIC  };


                                %Find which SLVJ trial resulted in the greatest peak activation for 
                                %each muscle
                                TrialforPeakSLVJ = MVICTrialNumber(   PeakMVICs_MuscleQ == PeakMVICs(q)  );

                            %End the if statement within HC68        
                            end



                        end%End If statement, for each participant
                        


%% Show Message Boxes

                        %Only show message boxes if we told the code to do so
                        if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )
                        
                        
                            %Create pop-up dialog box displaying the value of minimum power absorption AND generation
                            MSGBox1 = msgbox( { [ '\fontsize{20} Task With Highest MVIC for ', MuscleID{q}, ' of ', ParticipantList{n}, ' is '  TaskforPeakMVIC ' with ' num2str( PeakMVICs_MuscleQ( IndexofTaskforPeakMVIC ) ), RawHoppingUnits_string  ]   }  , CreateStruct);
    
                            %Don't execute the next line of code until user responds to dialog box above
                            uiwait( MSGBox1 )
                            
                            
                            
                            %Create pop-up dialog box displaying the value of minimum power absorption AND generation
                            MSGBox2 = msgbox( { [ '\fontsize{20} Chosen ', MVICTasks{ PeakMVICs_MuscleQ == PeakMVICs(q)  }, ' activation value for ', MuscleID{q}, ' of ', ParticipantList{n}, ' is '  num2str( PeakMVICs(q) ), RawHoppingUnits_string, 'from ', cell2mat( TrialforPeakSLVJ ) ]   }  , CreateStruct);
    
                            %Don't execute the next line of code until user responds to dialog box above
                            uiwait( MSGBox2 )

                        end
                        
                        





                   end %End q Loop - Muscle ID 



%% Store Peak MVICs in Data Structure


                   %Make a table showing the peak muscle activation for each muscle
                    PeakMVICs = array2table(PeakMVICs,'VariableNames',MuscleID);

                    %Make a table showing the peak muscle activation for each muscle
                    PeakMVICs_RectifiedNoBandpass = array2table(PeakMVICs_RectifiedNoBandpass,'VariableNames',MuscleID);

                    %Make a table showing the peak muscle activation for each muscle
                    PeakMVICs_NormalizeMSLVJ = array2table(PeakMVICs_NormalizeMSLVJ,'VariableNames',MuscleID);

                     %Store the peak muscle activation table, for normalizing hopping EMG, in the data structure
                    David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG',LimbID{r},'PeakMVICs',PeakMVICs);

                     %Store the peak muscle activation for normalizing MSLVJ EMG in the data structure
                    David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG',LimbID{r},'PeakMVICs_NormalizeMSLVJ', PeakMVICs_NormalizeMSLVJ );
                    
                    %Store the peak muscle activation, for comparing with Eugene's data, in the data structure
                    David_DissertationDataStructure = setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n}, 'HoppingEMG', LimbID{r},'PeakMVICs_SLHR_RectifiedNoBandpass', PeakMVICs_RectifiedNoBandpass);
                        
                    %Need to create a new data structure containing the EMG data for Limb R - since
                    %we added new data to the data structure, the old data structure variables won't
                    %be updated
                    EMGDataforLimbR_DataStructure = getfield( David_DissertationDataStructure, QualvsPostQualData{ l }, GroupList{ m }, ParticipantList{ n }, DataCategories{ o }, LimbID{ r } );






                end %End r Loop - Limb ID 

                
            
            end % End o Loop - Data Categories
                        
            
        end %End n loop - Participant ID
        
    end %End m Loop - Group ID
    
end %End l Loop - Quals Data



clearvars -except David_DissertationDataStructure QualvsPostQualData GroupList_DialogueBox GroupList ATxParticipantList ControlParticipantList DataCategories_HoppingKinematicsKinetics ControlLimbID ATxLimbID GRFSampHz EMGSampHz MoCapSampHz ATxParticipantMass ControlParticipantMass CreateStruct DataCategories EMGID lasterror RawHoppingUnits_string

clc


%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end