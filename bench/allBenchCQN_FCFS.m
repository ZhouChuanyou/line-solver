wantHighLoad = true;
wantLightLoad = true;
wantRepairmen = true;

%% bench_CQN_FCFS_rm_lightload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_midload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_highload
clearvars -except want*;
if wantHighLoad && wantRepairmen
    bench_CQN_FCFS_rm_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_hicv_lightload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_hicv_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_hicv_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_hicv_midload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_hicv_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_hicv_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_hicv_highload
clearvars -except want*;

if wantHighLoad && wantRepairmen
    bench_CQN_FCFS_rm_hicv_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_hicv_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_hicv_lightload
clearvars -except want*;
if wantLightLoad
    bench_CQN_FCFS_hicv_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_hicv_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_hicv_midload
clearvars -except want*;
if wantLightLoad
    bench_CQN_FCFS_hicv_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_hicv_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_hicv_highload
clearvars -except want*;
if wantHighLoad
    bench_CQN_FCFS_hicv_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_hicv_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_multiserver_lightload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_multiserver_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_multiserver_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_multiserver_lightload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_multiserver_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_multiserver_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_multiserver_highload
clearvars -except want*;
if wantHighLoad && wantRepairmen
    bench_CQN_FCFS_rm_multiserver_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_multiserver_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_multiserver_hicv_lightload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_multiserver_hicv_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_multiserver_hicv_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_multiserver_hicv_midload
clearvars -except want*;
if wantLightLoad && wantRepairmen
    bench_CQN_FCFS_rm_multiserver_hicv_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_multiserver_hicv_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_rm_multiserver_hicv_highload
clearvars -except want*;
if wantHighLoad && wantRepairmen
    bench_CQN_FCFS_rm_multiserver_hicv_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_rm_multiserver_hicv_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_multiserver_lightload
clearvars -except want*;
if wantLightLoad
    bench_CQN_FCFS_multiserver_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_multiserver_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_multiserver_midload
clearvars -except want*;
if wantLightLoad
    bench_CQN_FCFS_multiserver_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_multiserver_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_multiserver_highload
clearvars -except want*;
if wantHighLoad
    bench_CQN_FCFS_multiserver_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_multiserver_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_multiserver_hicv_lightload
clearvars -except want*;
if wantLightLoad
    bench_CQN_FCFS_multiserver_hicv_lightload;
    fprintf(1,'\t\nbench_CQN_FCFS_multiserver_hicv_lightload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_multiserver_hicv_midload
clearvars -except want*;
if wantLightLoad
    bench_CQN_FCFS_multiserver_hicv_midload;
    fprintf(1,'\t\nbench_CQN_FCFS_multiserver_hicv_midload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end

%% bench_CQN_FCFS_multiserver_hicv_highload
clearvars -except want*;
if wantHighLoad
    bench_CQN_FCFS_multiserver_hicv_highload;
    fprintf(1,'\t\nbench_CQN_FCFS_multiserver_hicv_highload: ErrQ: %.3f %.3f %.3f ErrW: %.3f %.3f %.3f ErrU: %.3f %.3f %.3f ErrT: %.3f %.3f %.3f ', mean(ERRQ(:,1)), mean(ERRQ(:,2)), mean(ERRQ(:,3)), mean(ERRR(:,1)), mean(ERRR(:,2)),mean(ERRR(:,3)), mean(ERRU(:,1)), mean(ERRU(:,2)), mean(ERRU(:,3)), mean(ERRX(:,1)), mean(ERRX(:,2)), mean(ERRX(:,3)))
end