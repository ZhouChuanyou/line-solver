%% run all examples
format compact
warning on backtrace
clc
fprintf(1,'<strong>This script runs all LINE examples.</strong>\n');
fprintf(1,'The current workspace will be cleared and figures will be closed. \n');
fprintf(1,'Please press a key to continue or CTRL-C to terminate.\n');
%pause; clc
clear;
close all;

%% LINE examples
fprintf(1,'\n<strong>RUNNING: example_closedModel_*</strong>');
fprintf(1,'\n\nExample: <strong>example_closedModel_1</strong>\n'); 
fprintf(1,'This example shows all solvers on a basic single-class closed model.\n')
clear; example_closedModel_1; fprintf(1,'Pausing...'); pause(3.0); 

fprintf(1,'\n\nExample: <strong>example_closedModel_2</strong>\n'); 
fprintf('This example shows a model with a multiclass FCFS station.\n')
clear; example_closedModel_2; fprintf(1,'Pausing...'); pause(3.0); 

fprintf(1,'\n\nExample: <strong>example_closedModel_3</strong>\n'); 
fprintf('This example shows the exact solution of a product-form queueing network.\n')
fprintf(1,'In this example we also calculate performance indexes by chain.\n')

clear; example_closedModel_3; fprintf(1,'Pausing...'); pause(3.0); 

fprintf(1,'\n\nExample: <strong>example_closedModel_4</strong>\n'); 
fprintf(1,'This example shows state space generation for a station.')
clear; example_closedModel_4;  space, spaceRunning, spaceStarted, fprintf(1,'Pausing...'); pause(3.0); 

fprintf(1,'\n\nExample: <strong>example_closedModel_5</strong>\n'); 
fprintf(1,'This example shows a 1-line solution of a cyclic queueing network.\n');
clear; example_closedModel_5; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\n<strong>RUNNING: example_initState_*</strong>');
fprintf(1,'\n\nExample: <strong>example_initState_1</strong>\n'); 
fprintf(1,'This example shows the execution of the transient solver on a 2-class 2-node class-switching model.')
clear; example_initState_1; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end 
fprintf(1,'\n\nExample: <strong>example_initState_2</strong>\n'); 
fprintf(1,'This example shows the execution of the transient solver on a 2-class 2-node class-switching model.')
clear; example_initState_2; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end
%%
fprintf(1,'\n<strong>RUNNING: example_openModel_*</strong>');
fprintf(1,'\n\nExample: <strong>example_openModel_1</strong>\n'); 
clear; example_openModel_1; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_openModel_2</strong>\n'); 
clear; example_openModel_2; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_openModel_3</strong>\n'); 
clear; example_openModel_3; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\n<strong>RUNNING: example_mixedModel_*</strong>');
fprintf(1,'\n\nExample: <strong>example_mixedModel_1</strong>\n'); 
clear; example_mixedModel_1; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\n<strong>RUNNING: example_stateProbabilities</strong>');
fprintf(1,'\n\nExample: <strong>example_stateProbabilities_1</strong>\n'); 
clear; example_stateProbabilities_1; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_stateProbabilities_2</strong>\n'); 
clear; example_stateProbabilities_2; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\n<strong>RUNNING: example_cdfRespT_*</strong>');
fprintf(1,'\n\nExample: <strong>example_cdfRespT_1</strong>\n'); 
clear; example_cdfRespT_1; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end; 
fprintf(1,'\n\nExample: <strong>example_cdfRespT_2</strong>\n'); 
clear; example_cdfRespT_2; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end; 
%fprintf(1,'\n\nExample: <strong>example_cdfRespT_3</strong>\n'); 
%clear; example_cdfRespT_3; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end; 
fprintf(1,'\n\nExample: <strong>example_cdfRespT_4</strong>\n'); 
clear; example_cdfRespT_4; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end; 
fprintf(1,'\n\nExample: <strong>example_cdfRespT_5</strong>\n'); 
clear; example_cdfRespT_5; fprintf(1,'Pausing...'); pause(3.0); try close(handleFig); end; 
%%
fprintf(1,'\n<strong>RUNNING: example_randomEnvironment_*</strong>');
fprintf(1,'\n\nExample: <strong>example_randomEnvironment_1</strong>\n'); 
clear; example_randomEnvironment_1; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_randomEnvironment_2</strong>\n'); 
clear; example_randomEnvironment_2; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\n<strong>RUNNING: example_layeredModel_*</strong>');
fprintf(1,'\n\nExample: <strong>example_layeredModel_1</strong>\n'); 
clear; example_layeredModel_1; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_layeredModel_2</strong>\n'); 
clear; example_layeredModel_2; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\n<strong>RUNNING: example_misc_*</strong>');
fprintf(1,'\n\nExample: <strong>example_misc_1</strong>\n'); 
fprintf(1,'This example shows how to solve only for selected performance indexes.\n');
clear; example_misc_1; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_misc_2</strong>\n'); 
clear; example_misc_2; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_misc_3</strong>\n'); 
fprintf(1,'This example illustrates the solution of DPS models.\n')
clear; example_misc_3; fprintf(1,'Pausing...'); pause(3.0); 
fprintf(1,'\n\nExample: <strong>example_misc_4</strong>\n'); 
fprintf(1,'This example shows that LINE automatically checks if a solver is feasible for a given model.\n');
fprintf(1,'If not, an empty result set is returned.\n');
clear; example_misc_4; fprintf(1,'Pausing...'); pause(3.0); 
%%
fprintf(1,'\nExamples completed.\n')
