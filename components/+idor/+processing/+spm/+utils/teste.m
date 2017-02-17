categories = { 'sentenca.*jus.*', 'sentenca.*pre.*', 'sentenca.*gan.*', 'sentenca.*bon.*', 'sentenca.*cor.*', 'sentenca.*rud.*' };
for k=1:length( categories )
    def(k).pres_type = 'Sound';
    def(k).pres_codes = categories(k);
    def(k).pres_termination_codes = { 'fim_sentenca' };
    def(k).pres_termination_types = { 'Picture' };
    def(k).spm_name = categories{k}(11:end-2);
    def(k).spm_fix_duration = [];
    def(k).spm_pmod = '';
end

ind = length(def)+1;

def(ind).pres_type = 'Response';
def(ind).pres_codes = { '\<16>\', '\<32\>' };
def(ind).pres_termination_codes = [];
def(ind).pres_termination_types = [];
def(ind).spm_name = 'MOTOR';
def(ind).spm_fix_duration = 0;
def(ind).spm_pmod = '';

logdir = 'Z:/PRJ1406_SINTAXE_E_VALORES/03_PROCS/LOGS_PRESENTATION';
files = dir( fullfile(logdir, 'SUBJ002*RUN1*') );
logfile = files(1).name;
conditions = log_to_condition( fullfile(logdir,logfile), def );