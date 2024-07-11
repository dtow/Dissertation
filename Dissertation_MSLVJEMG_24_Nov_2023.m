%% SECTION 1 - Load Data Structure

%Load data structure
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

%First field within data structure = data from after having completed quals
QualvsPostQualData =  {'Post_Quals'};
%Second field = group list
GroupList = {'ATx', 'Control'}; 
%Third field = participant list 
ATxParticipantList = { 'ATx07', 'ATx08', 'ATx10', 'ATx12', 'ATx17', 'ATx18', 'ATx19', 'ATx21', 'ATx24', 'ATx25', 'ATx27', 'ATx34', 'ATx38', 'ATx41', 'ATx44', 'ATx50', 'ATx36', 'ATx49', 'ATx39', 'ATx74', 'ATx65',...
    'ATx14' };
ATxParticipantList = ATxParticipantList( 1, [ 2, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 ] );
ControlParticipantList = { 'HC01', 'HC05', 'HC06', 'HC11', 'HC12', 'HC17', 'HC18', 'HC19', 'HC20', 'HC21', 'HC25', 'HC42', 'HC45', 'HC44', 'HC48', 'HC65' };
ControlParticipantList = ControlParticipantList( [5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 ] );
%4th field = data type
DataCategories = {'MSLVJEMG'};
%5th field = limb ID
EMGID = {'MVIC'};
%6th field = trial number
MSLVJTrialNumber = {'Trial1'};

%Load the Mass data from the data structure
MassLog = David_DissertationDataStructure.Post_Quals.AllGroups.MassLog;

%String for labeling y-axis of non-normalized EMG
RawMSLVJUnits_string = 'Voltage (mV)';


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







 %% SECTION 3 - Process MSLVJ EMG
    
    
%Want to clear the errors for the new section
lasterror = [];
    


%Need to downsample EMG to match number of kinematic data points
NumberofElementstoAverageforDownSampling = EMGSampHz / MoCapSampHz;

%Set time step for integrating EMG
TimeInterval_forIntegratingEMG = 1 ./ EMGSampHz;





            
%Create a prompt so we can manually enter the group of interest
ShowAnyPlotsPrompt =  'Show Any Plots ?' ;

%Use inputdlg function to create a dialogue box for the prompt created above.
%First arg is prompt, 2nd is title
ShowAnyPlots_Cell = inputdlg( [ '\fontsize{15}' ShowAnyPlotsPrompt ], 'Show Any Plots?', [1 150], {'No'} ,CreateStruct);



for l = 1 : numel(QualvsPostQualData)
    
    %Use get field to create a new data structure containing the list of groups. List of groups is
    %stored under the first field of the structure, QualvsPostQualData
    GroupListDataStructure = getfield(David_DissertationDataStructure,QualvsPostQualData{l});

%% Begin M For Loop - Loop Through Groups    
    
    for m = 2%1 : numel(GroupList)
        
        %Use get field to create a new data structure containing the list of participants. List of participants is
        %stored under the second field of the structure (the list of groups)
        ParticipantListDataStructure = getfield(GroupListDataStructure,GroupList{m} );

        %If Group being processed is ATx, set Participant List to contain list of ATx participants.
        %If Group being processed is Controls, set Participant List to contain list of Control
        %participants.
        if strcmp( GroupList{m}, 'ATx' )
            
            ParticipantList = ATxParticipantList;

            LimbID = {'InvolvedLimb','NonInvolvedLimb'};

            
        else
            
            ParticipantList = ControlParticipantList;
            
            LimbID = {'LeftLimb','RightLimb'};

            
        end
        
        
        MSLVJRate_ID = {'PreferredHz', 'TwoHz', 'TwoPoint3Hz'};
        
        
        
        
%% !!! Begin N For Loop - Loop Through Participants  !!!
        
        for n = 14 : 15%1 : numel(ParticipantList)
            
            
        
            %Create a prompt so we can manually enter the group of interest
            ShowPlotsPrompt = [ 'Show Plots for  ', ParticipantList{n}, '?' ];

            %Use inputdlg function to create a dialogue box for the prompt created above.
            %First arg is prompt, 2nd is title
            ShowPlots_Cell = inputdlg( [ '\fontsize{15}' ShowPlotsPrompt ], 'Show Plots?', [1 150], {'No'} ,CreateStruct);


            
            
%% Set Limb ID, MSLVJ Rate ID               
            
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



            elseif strcmp( ParticipantList{ n }, 'ATx12'  ) || strcmp( ParticipantList{n}, 'ATx14'  ) || strcmp( ParticipantList{n}, 'ATx27'  ) || strcmp( ParticipantList{n}, 'ATx34'  ) || strcmp( ParticipantList{n}, 'ATx44'  ) ||...
                    strcmp( ParticipantList{n}, 'ATx50'  ) || strcmp( ParticipantList{ n }, 'ATx100'  )
             
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
            
            
        
            
            
            
            %Use get field to create a new data structure containing the list of data categories. Stored under the 3rd field of the structure (the list of participants)
            ListofDataCategorieswithinParticipantN_DataStructure = getfield(ParticipantListDataStructure,ParticipantList{n});
            
            
             

             
%% BEGIN O For Loop - Loop Through Data Categories             
            for o = 1 : numel(DataCategories)
                

                %Use getfield to create a new data structure containing the list of limbs, for the EMG data.
                MSLVJEMG_DataStructure = getfield( ListofDataCategorieswithinParticipantN_DataStructure, 'MSLVJEMG' );

                %Use getfield to create a new data structure containing the list of limbs, for the  MVIC
                %data - the MVIC data is stored in the HoppingEMG field
                HoppingEMG_DataStructure = getfield( ListofDataCategorieswithinParticipantN_DataStructure, 'HoppingEMG' );
                
                %Use getfield to create a new data structure containing the list of limbs, for the GRF and Kinematics data.
                MSLVJGRFandKin_DataStructure = getfield (ListofDataCategorieswithinParticipantN_DataStructure, 'MSLVJKinematicsKinetics');

                
                
                

%% !!!! Begin A For Loop - Loop Through Limbs !!!!            
                
                for a = 1% : numel(LimbID)
                                        
                    
%% Set Muscle IDs for Involved vs Non-Involved Limb                    
                    
                    
                    %For ATx07, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                    if  strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL' };
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx08'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                         
                         
                     %For ATx21, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx19 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                        
                    %For ATx18, Involved Limb is Right Limb. Tell the code that the MuscleID should
                    %use 'R' in front of each muscle 
                     elseif strcmp( ParticipantList{n}, 'ATx24'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                         %Set the muscle ID list for ATx19 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx25'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx34'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};





                    elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx36 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx36, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx36'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};





                    elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx38 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx38, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx38'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx39 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx39, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx39'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx39 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx41 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx41, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx41'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx44'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx44'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx49 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx49, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx49'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx49 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx50'  ) && strcmp( LimbID{ a}, 'InvolvedLimb')

                         %Set the muscle ID list for ATx07 involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                     %For ATx07, Non-Involved Limb is LeftLimb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx50'  ) && strcmp( LimbID{ a}, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx07 non-involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx65'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx65 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx65, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx65'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx65 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};



                    elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{ a }, 'InvolvedLimb')

                         %Set the muscle ID list for ATx74 involved limb
                         MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                         
                     %For ATx74, Non-Involved Limb is Left Limb. Tell the code that the MuscleID
                    %should use 'L' in front of each muscle    
                     elseif strcmp( ParticipantList{n}, 'ATx74'  ) && strcmp( LimbID{ a }, 'NonInvolvedLimb')

                        %Set the muscle ID list for ATx74 non-involved limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};
                         
                         
                         
                    %For the Control group, tell the code that the MuscleID should use 'R' in front
                    %of each muscle for the Right Limb
                    elseif strcmp(LimbID{ a},'RightLimb')

                        %Set the muscle ID list for the control group right limb
                        MuscleID = {'RMGas','RLGas','RSol','RPL','RTA'};
                        
                     %For the Control group, tell the code that the MuscleID should use 'L' in front
                    %of each muscle for the LeftLimb
                     else

                        %Set the muscle ID list for the control group left limb
                        MuscleID = {'LMGas','LLGas','LSol','LPL','LTA'};

                     %End the if statement for setting the muscle list   
                     end 
                    
                     

                    
                    %Use getfield to create data structure containing the EMG data for Limb A. This
                    %data structure will have the list of muscles as well as the resting EMG data
                    MSLVJEMG_LimbA_DataStructure = getfield(MSLVJEMG_DataStructure, LimbID{a} );
                    
                    %Use getfield to create data structure containing the EMG data for Limb A. This
                    %data structure will have the MVIC data
                    HoppingEMG_LimbA_DataStructure = getfield( HoppingEMG_DataStructure, LimbID{a} );
                    
                    %Use getfield to create data structure containing the GRF and Kinematics data
                    %for Limb A.
                    MSLVJGRFandKin_LimbA_DataStructure = getfield( MSLVJGRFandKin_DataStructure, LimbID{a} );

                    
                    
                    %Create a variable to hold the resting EMG data
                    RestingEMG = HoppingEMG_DataStructure.RestingEMG;

                    
                    
                    
                        
%% !!! Begin Q For Loop - Loop Through Muscles !!!                    
                        
                        for q = 1 : numel(MuscleID)
                           



    %% Find mean of the Qth muscle's resting EMG. 
                            MuscleQ_RestingEMG = getfield( RestingEMG,MuscleID{ q } );

                            MuscleQ_RestingEMGMean = mean(getfield(RestingEMG,MuscleID{q}));

                            %Need to index into data structure and find the peak MVIC value for the Qth
                            %muscle
                            MuscleQ_MVIC_Value = getfield( HoppingEMG_LimbA_DataStructure.PeakMVICs_NormalizeMSLVJ, MuscleID{ q } );


                                if strcmp( ParticipantList{ n }, 'HC25' ) && strcmp( LimbID{ a }, 'RightLimb' )

                                    %HC25 has the jumps spread over two trials
                                    MSLVJTrialNumber = {'Trial1', 'Trial2'};


                                else

                                    %For now, we're only processing one trial of hopping per hopping
                                    %rate
                                    MSLVJTrialNumber = {'AllTrials'};

                                end

                             
                            
                                %Initialize variables to be used within the B loop. These will reset
                                %for each hopping rate
                                FirstDataPointofFlight_GRFData = NaN(10,numel(MSLVJTrialNumber));                                
                                LastDataPointofFlight_GRFData = NaN(10,numel(MSLVJTrialNumber)); 
                                FirstDataPointofFlight_EMGData = NaN(10,numel(MSLVJTrialNumber));                                
                                LastDataPointofFlight_EMGData = NaN(10,numel(MSLVJTrialNumber)); 
                                
                                FirstDataPointofGContact_GRFData = NaN(10,numel(MSLVJTrialNumber));                                
                                LastDataPointofGContact_GRFData = NaN(10,numel(MSLVJTrialNumber)); 
                                FirstDataPointofGContact_EMGData = NaN(10,numel(MSLVJTrialNumber));                                
                                LastDataPointofGContact_EMGData = NaN(10,numel(MSLVJTrialNumber)); 
                                
                                FirstDataPointofHop_GRFData = NaN(10,numel(MSLVJTrialNumber));                                
                                LastDataPointofHop_GRFData = NaN(10,numel(MSLVJTrialNumber)); 
                                FirstDataPointofHop_EMGData = NaN(10,numel(MSLVJTrialNumber));                                
                                LastDataPointofHop_EMGData = NaN(10,numel(MSLVJTrialNumber)); 
                                
                                
                                LengthofHop_GRFta = NaN(10,numel(MSLVJTrialNumber));      
                                LengthofContactPhase_GRFData = NaN(10,numel(MSLVJTrialNumber));      
                                LengthofFlightPhase_GRFData = NaN(10,numel(MSLVJTrialNumber)); 
                                LengthofHop_EMGData = NaN(10,numel(MSLVJTrialNumber));      
                                LengthofContactPhase_EMGData = NaN(10,numel(MSLVJTrialNumber));      
                                LengthofFlightPhase_EMGData = NaN(10,numel(MSLVJTrialNumber)); 
                                
                                
                                
    %% Begin P For Loop - Once For Each Trial (Set of Hops)

                                for p = 1 : numel(MSLVJTrialNumber)


                                    %% Index into Data Structure, within P Loop (MSLVJ Trial #)
    
                                    %Use getfield to create a new data structure containing the EMG data for
                                    %the pth hopping trial
                                    MSLVJEMG_TrialP_Table = getfield( MSLVJEMG_LimbA_DataStructure, MSLVJTrialNumber{ p } );

                                    %Use getfield to create a new data structure containing the GRF
                                    %and Kinematics data for the Pth hopping trial
                                    MSLVJGRFandKin_TrialP_Table = getfield( MSLVJGRFandKin_LimbA_DataStructure, MSLVJTrialNumber{p});


                                    %Use getfield to create a new data structure containing the EMG data for
                                    %the Qth muscle in the pth hopping trial
                                    MuscleQTrialP = getfield( MSLVJEMG_TrialP_Table,MuscleID{ q } );

                                    %Pull out the vertical GRF data for the Pth hopping trial
                                    vGRFTrialP = MSLVJGRFandKin_TrialP_Table.FP3_2;

                                    


        %% Remove DC Offset

                                    %Subtract mean of resting EMG from raw EMG to remove DC offset
                                    MuscleQ_DCOffsetRemoved = MuscleQTrialP - MuscleQ_RestingEMGMean;

                                    %Create a time vector to be used for the x-axis of plots
                                    TimeVector = (1:numel(MuscleQ_DCOffsetRemoved))./ EMGSampHz;

                                    %Only show the figure below if we told the code to show all figures
                                    %for Participant N
                                    if  strcmp( cell2mat( ShowPlots_Cell ), 'Yes' )
                                    
                                        %Plot the EMG with and without DC offset to check the quality of the
                                        %removal
                                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of DC Offset Removal ', GroupList{m}, ' ', ParticipantList{n}, ' ' , LimbID{ a }, '  ', MuscleID{q}, ' ', MSLVJTrialNumber{p} ])
                                        X1 = subplot(2,1,1);
                                        plot(TimeVector',MuscleQTrialP,'LineWidth',1.5,'Color','#0072BD')
                                        xlabel('Time (s)')
                                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                        ylabel( RawMSLVJUnits_string )
                                        title('Raw EMG - with DC Offset')

                                        X2 = subplot(2,1,2);
                                        plot(TimeVector',MuscleQ_DCOffsetRemoved,'LineWidth',1.5,'Color','#7E2F8E')
                                        xlabel('Time (s)')
                                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                        ylabel( RawMSLVJUnits_string )
                                        title('Raw EMG - DC Offset Removed')

                                        linkaxes( [ X1 X2 ], 'xy')

                                        pause

                                        close all
                                        
                                         %End the If statement - whether to show the plot for Participant N   
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
                                PaddedData = [ CorrectedFirstHalfofInvertedData; MuscleQ_DCOffsetRemoved; CorrectedSecondHalfofInvertedData];
                                
                                %Will need to segment original data back out from padded data.
                                OriginalDataIndices = (HalfLengthofData_forPadding +1 ) :  (HalfLengthofData_forPadding + numel( MuscleQ_DCOffsetRemoved ) );




%% Check Padding of Data


                                %Create a time vector to be used for the x-axis of plots
                                TimeVector_PaddedData = ( 1 : numel( PaddedData ) )./EMGSampHz;
    
                                %Only show plots if we told the code to do so
                                if strcmp( cell2mat( ShowPlots_Cell), 'Yes' ) || strcmp( cell2mat( ShowPlots_Cell), 'Y' )
    
                                    %Plot the EMG with and without DC offset to check the quality of the
                                    %removal
                                    figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Padding of Data ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{ a}, '  ', MuscleID{q}, '  ' , MSLVJTrialNumber{p}] )
                                    X1 =  subplot(2,1,1);
                                    plot(TimeVector', MuscleQ_DCOffsetRemoved, 'LineWidth',2)
                                    xlabel('Time (s)')
                                    xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                    ylabel( RawMSLVJUnits_string )
                                    title('Raw MVIC - DC Offset Removed')
        
                                    subplot(2,1,2)
                                    X2 = plot( TimeVector_PaddedData', PaddedData, 'LineWidth',2);
                                    xlabel('Time (s)')
                                    xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                                    ylabel( RawMSLVJUnits_string )
                                    title('Padded Raw MVIC - DC Offset Removed')
        
                                    %Link the axes so any zooming in/out in one plot changes the other plot
                                    linkaxes( [ X1 X2 ], 'xy')
        
                                    pause

                                    close all
    
                                end



    %% Notch Filter

                                %Use a notch-filter set to filter out any 60 Hz noise from equipment
                                MuscleQ_NotchFilteredAt60Hz = BasicFilter( PaddedData, EMGSampHz,60,2,'notch');

                                %Notch filter at 50 Hz
                                MuscleQ_NotchFilteredAt50Hz = BasicFilter(MuscleQ_NotchFilteredAt60Hz,1500,50,2,'notch');

                                %David_DissertationDataStructure = setfield(David_DissertationDataStructure,'PilotDataforQuals',GroupList{m}, ParticipantList{n},'MSLVJKinematicsKinetics','IndividualHops','RightLimb',...
                                    %'GasMed_MTU','BeginGroundContact_GRFFrames',RLimb_GContactBegin_FrameNumbers_GRFHz);



 %% Bandpass Filter

                                    %Bandpass filter with low-pass cut off of 500 Hz and high-pass
                                    %cut-off of 10 Hz, 2nd order
                                    MuscleQ_BandpassFiltered_10Hz = BasicFilter( PaddedData,1500,[10 500], 2, 'bandpass');

                                    %Bandpass filter with low-pass cut off of 500 Hz and high-pass
                                    %cut-off of 10 Hz, 2nd order
                                    MuscleQ_BandpassFiltered_30Hz = BasicFilter( PaddedData,1500,[30 500], 2, 'bandpass');
                                     
                                    
                                    

%% High pass filter the bandpass filtered
       
                                    %Highpass filter the bandpass filtered data. Will need for this coherence analysis. Use a 4th order high-pass filterwith low-pass cut off of 250 Hz
                                    MuscleQ_Highpassed4Coherence = BasicFilter( MuscleQ_BandpassFiltered_10Hz, 1500, 250, 2, 'highpass');
                                    

                                    
%% Rectify MSLVJ EMG - 10 Hz Bandpass                       


                                    %Set MuscleQ_Rectified to be the same as
                                    %MuscleQ_BandPassFiltered. We will overwrite this later
                                    MuscleQ_Rectified_10HzBandpass = MuscleQ_BandpassFiltered_10Hz;

                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_10HzBandpass = MuscleQ_BandpassFiltered_10Hz < 0;

                                    %Multiply all negative values in MuscleQ_Rectified by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_10HzBandpass(MuscleQ_NegativeValues_10HzBandpass) = MuscleQ_Rectified_10HzBandpass(MuscleQ_NegativeValues_10HzBandpass)*(-1);

                                    
                                    %Set MuscleQ_Rectified_forCoherence to be the same as
                                    %MuscleQ_Highpassed4Coherence. We will overwrite this later
                                    MuscleQ_Rectified_forCoherence = MuscleQ_Highpassed4Coherence;
                                    
                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_forCoherence = MuscleQ_Highpassed4Coherence < 0;
                                    
                                    %Multiply all negative values in MuscleQ_Rectified_forCoherence by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_forCoherence(MuscleQ_NegativeValues_forCoherence) =...
                                        MuscleQ_Rectified_forCoherence( MuscleQ_NegativeValues_forCoherence )*(-1);
                                    
                                    

%% Rectify MSLVJ EMG - 30 Hz Bandpass     

                                    %Set MuscleQ_Rectified to be the same as
                                    %MuscleQ_BandPassFiltered. We will overwrite this later
                                    MuscleQ_Rectified_30HzBandpass = MuscleQ_BandpassFiltered_30Hz;

                                    %Find all negative values in MuscleQ_BandpassFiltered
                                    MuscleQ_NegativeValues_30HzBandpass = MuscleQ_BandpassFiltered_30Hz < 0;

                                    %Multiply all negative values in MuscleQ_Rectified by -1 so that
                                    %all values are now positive
                                    MuscleQ_Rectified_30HzBandpass(MuscleQ_NegativeValues_30HzBandpass) = MuscleQ_Rectified_30HzBandpass(MuscleQ_NegativeValues_30HzBandpass)*(-1);
                             

                                    
                                    
%% Linear Envelope MSLVJ EMG                       

                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 3 Hz
                                    MuscleQ_Smoothed_10HzBandpass = BasicFilter_SinglePass(MuscleQ_Rectified_10HzBandpass,1500, 3.5, 2,'lowpass');

                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 3 Hz
                                    MuscleQ_DoublePassSmoothed_10HzBandpass = BasicFilter(MuscleQ_Rectified_10HzBandpass,1500, 4.5, 2,'lowpass');


                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 3 Hz
                                    MuscleQ_Smoothed_30HzBandpass = BasicFilter_SinglePass(MuscleQ_Rectified_30HzBandpass,1500, 3.5, 2,'lowpass');

                                    %Smooth the Muscle Q data using a 2nd order low-pass filter with a cut-off
                                    %Hz of 3 Hz
                                    MuscleQ_DoublePassSmoothed_30HzBandpass = BasicFilter(MuscleQ_Rectified_30HzBandpass,1500, 4.5, 2,'lowpass');

                                    

                                    
         %% Normalize MSLVJ EMG                           

                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_Normalized_10HzBandpass = (MuscleQ_Smoothed_10HzBandpass./MuscleQ_MVIC_Value).*100;

                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_DoublePassNormalized_10HzBandpass = (MuscleQ_DoublePassSmoothed_10HzBandpass./MuscleQ_MVIC_Value).*100;



                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_Normalized_30HzBandpass = (MuscleQ_Smoothed_30HzBandpass./MuscleQ_MVIC_Value).*100;

                                    %Normalize MuscleQ by dividing by MuscleQ's MVIC value then
                                    %multiplying by 100
                                    MuscleQ_DoublePassNormalized_30HzBandpass = (MuscleQ_DoublePassSmoothed_30HzBandpass./MuscleQ_MVIC_Value).*100;
                                    


%% Remove Padding

                        MuscleQ_BandpassFiltered_10Hz_Padded = MuscleQ_BandpassFiltered_10Hz;
                        MuscleQ_Rectified_10HzBandpass_Padded = MuscleQ_Rectified_10HzBandpass;
                        MuscleQ_Smoothed_10HzBandpass_Padded = MuscleQ_Smoothed_10HzBandpass;
                        MuscleQ_DoublePassSmoothed_10HzBandpass_Padded = MuscleQ_DoublePassSmoothed_10HzBandpass;
                        MuscleQ_Normalized_10HzBandpass_Padded = MuscleQ_Normalized_10HzBandpass;
                        MuscleQ_DoublePassNormalized_10HzBandpass_Padded = MuscleQ_DoublePassNormalized_10HzBandpass;

                        MuscleQ_BandpassFiltered_30Hz_Padded = MuscleQ_BandpassFiltered_30Hz;
                        MuscleQ_Rectified_30HzBandpass_Padded = MuscleQ_Rectified_30HzBandpass;
                        MuscleQ_Smoothed_30HzBandpass_Padded = MuscleQ_Smoothed_30HzBandpass;
                        MuscleQ_DoublePassSmoothed_30HzBandpass_Padded = MuscleQ_DoublePassSmoothed_30HzBandpass;
                        MuscleQ_Normalized_30HzBandpass_Padded = MuscleQ_Normalized_30HzBandpass;
                        MuscleQ_DoublePassNormalized_30HzBandpass_Padded = MuscleQ_DoublePassNormalized_30HzBandpass;


                        MuscleQ_NotchFilteredAt60Hz = MuscleQ_NotchFilteredAt60Hz( OriginalDataIndices );
                        MuscleQ_NotchFilteredAt50Hz = MuscleQ_NotchFilteredAt50Hz( OriginalDataIndices );
                        MuscleQ_BandpassFiltered_10Hz = MuscleQ_BandpassFiltered_10Hz( OriginalDataIndices );
                        MuscleQ_Smoothed_10HzBandpass = MuscleQ_Smoothed_10HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassSmoothed_10HzBandpass = MuscleQ_DoublePassSmoothed_10HzBandpass( OriginalDataIndices );
                        MuscleQ_Rectified_10HzBandpass = MuscleQ_Rectified_10HzBandpass( OriginalDataIndices );
                        MuscleQ_Normalized_10HzBandpass = MuscleQ_Normalized_10HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassNormalized_10HzBandpass = MuscleQ_DoublePassNormalized_10HzBandpass( OriginalDataIndices );
                        
                        MuscleQ_BandpassFiltered_30Hz = MuscleQ_BandpassFiltered_30Hz( OriginalDataIndices );
                        MuscleQ_Smoothed_30HzBandpass = MuscleQ_Smoothed_30HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassSmoothed_30HzBandpass = MuscleQ_DoublePassSmoothed_30HzBandpass( OriginalDataIndices );
                        MuscleQ_Rectified_30HzBandpass = MuscleQ_Rectified_30HzBandpass( OriginalDataIndices );
                        MuscleQ_Normalized_30HzBandpass = MuscleQ_Normalized_30HzBandpass( OriginalDataIndices );
                        MuscleQ_DoublePassNormalized_30HzBandpass = MuscleQ_DoublePassNormalized_30HzBandpass( OriginalDataIndices );
                        MuscleQ_Highpassed4Coherence = MuscleQ_Highpassed4Coherence( OriginalDataIndices );
                        MuscleQ_Rectified_forCoherence = MuscleQ_Rectified_forCoherence( OriginalDataIndices );


                        
%Only show plots if we told the code to do so

                        %Plot the EMG before and after smoothing to check the quality of the
                        %smoothjing
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Padding Removal ', ' ', GroupList{m}, ' ', ParticipantList{n}, ' ', LimbID{ a}, '  ',  MuscleID{q} ] )

                        subplot( 3, 1, 1 )
                        plot(TimeVector_PaddedData',MuscleQ_Rectified_10HzBandpass_Padded,'LineWidth',1.5)
                        hold on
                        plot(TimeVector_PaddedData',MuscleQ_Smoothed_10HzBandpass_Padded,'LineWidth',4)
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector_PaddedData( numel( TimeVector_PaddedData ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title(['Padded and Smoothed Data ', ParticipantList{n}, ' ', LimbID{ a} ] )
                        legend('MVIC Rectified','MVIC Smoothed');
                        hold off

                        subplot( 3, 1, 2 )
                        plot(TimeVector', MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5)
                        hold on
                        plot(TimeVector', MuscleQ_Smoothed_10HzBandpass,'LineWidth',4)
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title(['Rectified/Smoothed Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{ a}  ] )
                        legend('MVIC Rectified','MVIC Smoothed');
                        hold off
                        hold off

%                             subplot( 6, 1, 3 )
%                             plot(TimeVector', MuscleQ_Normalized,'LineWidth',1.5)
%                             xlabel('Time (s)')
%                             ylabel( RawMSLVJUnits_string )
%                             title(['Normalized Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{ a}  ] )
%                             legend('MVIC Rectified','MVIC Smoothed');
%                             hold off

                        subplot( 3, 1, 3 )
                        plot(TimeVector', MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5)
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title(['Bandpassed Data - Padding Removed ', ParticipantList{n}, ' ', LimbID{ a}  ] )
                        hold off


                       if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end


%% Plot Filtered Data


                        
                        %Plot the EMG before and after  filtering to check the quality of the
                        %filtering
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Filtering ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        X1 = subplot(5,1,1);
                        plot(TimeVector',MuscleQ_DCOffsetRemoved,'LineWidth',1.5,'Color','#0072BD')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('Raw EMG - DC Offset Removed')

                        X2 = subplot(5,1,2);
                        plot(TimeVector',MuscleQ_NotchFilteredAt60Hz,'LineWidth',1.5,'Color','#77AC30')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Notch Filtered @ 60 Hz')

                        X3 = subplot(5,1,3);
                        plot(TimeVector',MuscleQ_NotchFilteredAt50Hz,'LineWidth',1.5,'Color','#D95319')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Notch Filtered @ 50 Hz')

                        X4 = subplot(5,1,4);
                        plot(TimeVector',MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Bandpass Filtered - 10 Hz')

                        X5 = subplot(5,1,5);
                        plot(TimeVector',MuscleQ_BandpassFiltered_30Hz,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Bandpass Filtered - 30 Hz')

                        %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [X1 X2 X3 X4 X5], 'xy')

                        savefig( [ ParticipantList{ n }, '_', 'Check Quality of Filtering', '_', LimbID{ a }, '_', MuscleID{q} , '.fig' ] );


                        if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end
                            

%% Plot High-Pass Filtered Data

                        
                         %Plot the EMG before and after high-pass filtering (for coherence) to check the quality of the
                        %filtering
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of High-pass Filtering for Coherence ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        X1 = subplot(2,1,1);
                        plot(TimeVector',MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5,'Color','#0072BD')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Bandpass Filtered')

                        X2 = subplot(2,1,2);
                        plot(TimeVector',MuscleQ_Highpassed4Coherence,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                       xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG High-pass Filtered for Coherence')

                        %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [ X1 X2 ], 'xy')


                        if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end



%% Plot Rectified Data - 10 Hz Bandpass
                        

                        
                        %Plot the EMG before and after rectification to check the quality of the
                        %rectification - NOT for coherence
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Rectification - 10 Hz Bandpass Filter ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        X1 = subplot(4,1,1);
                        plot(TimeVector',MuscleQ_BandpassFiltered_10Hz,'LineWidth',1.5,'Color','#0072BD')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Bandpass Filtered - 10 Hz')

                        X2 = subplot(4,1,2);
                        plot(TimeVector',MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Rectified - 10 Hz Bandpass Filter')



                    
                        %Plot the EMG before and after rectification to check the quality of the
                        %rectification - NOT for coherence - 30 Hz Bandpass
                        X3 = subplot(4,1,3);
                        plot(TimeVector',MuscleQ_BandpassFiltered_30Hz,'LineWidth',1.5,'Color','#0072BD')
                        xlabel('Time (s)')
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Bandpass Filtered - 30 Hz')

                        X4 = subplot(4,1,4);
                        plot(TimeVector',MuscleQ_Rectified_30HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Rectified - 30 Hz Bandpass Filter')

                        %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [ X1 X2 X3 X4 ], 'xy')

                        savefig( [ ParticipantList{ n }, '_', 'Check Rectification', '_', LimbID{ a }, '_', MuscleID{q} , '.fig' ] );


                        if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end





%% Plot GRF and Rectified EMG

                        %Create a time vector for the GRF to use in creating plots
                        TimeVector_GRF = (1: numel(vGRFTrialP) )./GRFSampHz;

                        %Plot the Rectified EMG with vGRF
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Compare EMG with vGRF ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        X1 = subplot( 3, 1, 1 );
                        plot(TimeVector_GRF',vGRFTrialP,'LineWidth',1.5,'Color','#0072BD')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel('Vertical GRF (N)')
                        title('vGRF')

                        X2 = subplot( 3, 1, 2 );
                        plot(TimeVector',MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Rectified - 10 Hz Bandpass Filter')

                        X3 = subplot( 3, 1, 3 );
                        plot(TimeVector',MuscleQ_Rectified_30HzBandpass,'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Rectified - 30 Hz Bandpass Filter')

                        %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [ X1 X2 X3], 'x')

                        savefig( [ ParticipantList{ n }, '_', 'Compare EMG with vGRF', '_', LimbID{ a }, '_', MuscleID{q} , '.fig' ] );


                       if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end



%% Plot Rectified EMG For Coherence

                        %Plot the EMG before and after rectification to check the quality of the
                        %rectification - FOR coherence
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Rectification for Coherence ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        X1 = subplot(2,1,1);
                        plot(TimeVector', MuscleQ_Highpassed4Coherence, 'LineWidth',1.5,'Color','#0072BD')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Highpass Filtered for Coherence')

                        X2 = subplot(2,1,2);
                        plot(TimeVector', MuscleQ_Rectified_forCoherence, 'LineWidth',1.5,'Color','#7E2F8E')
                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Rectified for Coherence')

                        %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [ X1 X2 ], 'xy')


                        if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end
                            
                            




%% Plot Linear Enveloped Data
                        
                        %Plot the EMG before and after smoothing to check the quality of the
                        %smoothing
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Smoothing ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        sgtitle( ['Check Quality of Smoothing ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p} ] , 'FontSize', 20 )
                        X1 = subplot( 2, 1, 1 );
                        plot(TimeVector',MuscleQ_Rectified_10HzBandpass,'LineWidth',1.5,'Color','#0072BD')
                        hold on
                        plot(TimeVector',MuscleQ_Smoothed_10HzBandpass,'LineWidth',4)
                        plot(TimeVector',MuscleQ_DoublePassSmoothed_10HzBandpass,'LineWidth',1)

                        %Create a horizontal line at 0. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to black
                        L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                        L.LineWidth = 2;
                        L.Color = 'k';

                        %Create a horizontal line at -10. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to magenta
                        L2 = line( [min( TimeVector ), max( TimeVector ) ], [ -10, -10 ] );
                        L2.LineWidth = 2;
                        L2.Color = 'm';

                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title(['Check Quality of Smoothing - 10 Hz Bandpass Filter', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        legend('MSLVJ EMG Rectified - 10 Hz Bandpass Filter','Single Pass Filter - 3.5 Hz Cutoff', 'Double Pass Filter - 4.5 Hz Cutoff');
                        hold off




                        % Plot Linear Enveloped Data - 30 Hz Bandpass
                    
                        %Plot the EMG before and after smoothing to check the quality of the
                        %smoothing
                        X2 = subplot( 2, 1, 2);
                        plot(TimeVector',MuscleQ_Rectified_30HzBandpass,'LineWidth',1.5,'Color','#0072BD')
                        hold on
                        plot(TimeVector',MuscleQ_Smoothed_30HzBandpass,'LineWidth',4)
                        plot(TimeVector',MuscleQ_DoublePassSmoothed_30HzBandpass,'LineWidth',1)

                        %Create a horizontal line at 0. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to black
                        L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                        L.LineWidth = 2;
                        L.Color = 'k';

                        %Create a horizontal line at -10. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to magenta
                        L2 = line( [min( TimeVector ), max( TimeVector ) ], [ -10, -10 ] );
                        L2.LineWidth = 2;
                        L2.Color = 'm';

                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title(['Check Quality of Smoothing - 30 Hz Bandpass Filter', GroupList{m}, ' ', ParticipantList{n}, ' ' ,  MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        legend('MSLVJ EMG Rectified - 30 Hz Bandpass Filter','Single Pass Filter - 3.5 Hz Cutoff', 'Double Pass Filter - 4.5 Hz Cutoff');
                        hold off

                        %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [ X1 X2 ], 'xy')


                        savefig( [ ParticipantList{ n }, '_', 'Check Quality of Smoothing', '_', LimbID{ a }, '_', MuscleID{q} , '.fig' ] );


                        if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end




%% Plot Normalized Data 
                        
                        %Plot the EMG before and after normalization to check the quality of the
                        %normalization
                        figure('Color', '#F5F5DC','Units', 'Normalized', 'OuterPosition', [ 0.05, 0.05, 0.9, 0.9 ],'Name',['Check Quality of Normalization ', GroupList{m}, ' ', ParticipantList{n}, ' ' , MuscleID{q}, ' ', MSLVJTrialNumber{p}])
                        X1 = subplot(4,1,1);
                        plot(TimeVector',MuscleQ_Smoothed_10HzBandpass,'LineWidth',2,'Color','#0072BD')
                        hold on

                        %Create a horizontal line at 0. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to black
                        L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                        L.LineWidth = 2;
                        L.Color = 'k';

                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Smoothed - 10 Hz Bandpass Filter')
                        hold off

                        subplot(4,1,2)
                        X2 = plot(TimeVector',MuscleQ_Normalized_10HzBandpass,'LineWidth',2,'Color','#7E2F8E');
                        hold on

                        %Create a horizontal line at 0. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to black
                        L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                        L.LineWidth = 2;
                        L.Color = 'k';

                        xlabel('Time (s)')
                        xticks( 0 : 2 : TimeVector( numel( TimeVector ) ) )
                        ylabel('Normalized (%RC)')
                        title('MSLVJ EMG Normalized to Reference Contraction (Max Height Single-leg Vertical Jump) - 10 Hz Bandpass Filter')
                        hold off




                        % Plot Normalized Data - 30 Hz Bandpass
                    
                        %Plot the EMG before and after normalization to check the quality of the
                        %normalization
                        X3 = subplot(4,1,3);
                        plot(TimeVector',MuscleQ_Smoothed_30HzBandpass,'LineWidth',2,'Color','#0072BD')
                        hold on

                        %Create a horizontal line at 0. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to black
                        L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                        L.LineWidth = 2;
                        L.Color = 'k';

                        xlabel('Time (s)')
                        ylabel( RawMSLVJUnits_string )
                        title('MSLVJ EMG Smoothed - 30 Hz Bandpass Filter')
                        hold off

                        subplot(4,1,4)
                        X4 = plot(TimeVector',MuscleQ_Normalized_30HzBandpass,'LineWidth',2,'Color','#7E2F8E');
                        hold on

                        %Create a horizontal line at 0. Make it extend the entire time series length
                        %via min( TimeVector ) and max (TimeVector). Change size to 2
                        %and color to black
                        L = line( [min( TimeVector ), max( TimeVector ) ], [ 0, 0 ] );
                        L.LineWidth = 2;
                        L.Color = 'k';

                        xlabel('Time (s)')
                        ylabel('Normalized (%RC)')
                        title('MSLVJ EMG Normalized to Reference Contraction (Max Height Single-leg Vertical Jump) - 30 Hz Bandpass Filter')
                        hold off

                         %Use linkaxes so that any Zooming in applies to all subplots
                        linkaxes( [ X1 X2 X3 X4 ], 'xy')

                        savefig( [ ParticipantList{ n }, '_', 'Check Quality of Normalization', '_', LimbID{ a }, '_', MuscleID{q} , '.fig' ] );


                        if strcmp( cell2mat( ShowPlots_Cell), 'No' ) || strcmp( cell2mat( ShowPlots_Cell), 'N' )

                            close all

                        else

                            pause

                            close all

                        end
                            
                             %End the If statement - whether to show the plot for Participant N   
                                    
                                    
                                    

                                    





%% Store EMG Data in Data Structure                                    

                                    %Save the raw EMG in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Raw',MuscleQTrialP);

                                    %Save the DC offset removed EMG in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'DC_Offset_Removed',MuscleQ_DCOffsetRemoved);

                                    %Store the 60 Hz notch filtered EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'NotchFiltered_at60Hz',MuscleQ_NotchFilteredAt60Hz);

                                    %Store the 50 AND 60 Hz notch filtered EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'NotchFiltered_at50Hz',MuscleQ_NotchFilteredAt50Hz);

                                    %Store the bandpass filtered EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'BandpassFiltered_10HzCutoff',MuscleQ_BandpassFiltered_10Hz);

                                    %Store the bandpass filtered EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'BandpassFiltered_30HzCutoff',MuscleQ_BandpassFiltered_30Hz);
                                    
                                    
                                    %Store the highpass filtered EMG (for coherence)  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'HighpassFiltered_forCoherence', MuscleQ_Highpassed4Coherence );
                                    
                                    

                                    %Store the rectified EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Rectified_10HzBandpass',MuscleQ_Rectified_10HzBandpass);
                                    
                                    

                                    %Store the rectified EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Rectified_30HzBandpass',MuscleQ_Rectified_30HzBandpass);

                                    
                                     %Store the rectified EMG (for coherence)  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Rectified_forCoherence',MuscleQ_Rectified_forCoherence);

                                    
                                    
                                    %Store the smoothed EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Smoothed_10HzBandpass',MuscleQ_Smoothed_10HzBandpass);

                                    %Store the normalized EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Normalized_10HzBandpass',MuscleQ_Normalized_10HzBandpass);

                               

                                    
                                    %Store the smoothed EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Smoothed_30HzBandpass',MuscleQ_Smoothed_30HzBandpass);

                                    %Store the normalized EMG  in the data structure
                                    David_DissertationDataStructure =...
                                        setfield(David_DissertationDataStructure,'Post_Quals',GroupList{m}, ParticipantList{n},'MSLVJEMG',LimbID{a},MuscleID{q}, MSLVJTrialNumber{p},'Normalized_30HzBandpass',MuscleQ_Normalized_30HzBandpass);





                                end
                                



                        end

                    
                end
                
            end
            
        end
        
        
        
        
        
    end
    
    
end
                   

%Pop up a prompt stating there are no errors in this section, if all code was run
if isempty( lasterror )
    
    msgbox('\fontsize{15} NO ERRORS IN SECTION 3',CreateStruct);
    
else
    
    error = lasterror;
    msgbox(['\fontsize{15}' error.message 'Line ' num2str(error.stack.line) ]',CreateStruct);
    
end

