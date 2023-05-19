#ifndef HACKING_H_PA2UMYTB
#define HACKING_H_PA2UMYTB
enum hacking {
	PR_INFO,
	WATCH_DOG,
	KTHREAD,
	RCU,
	MUTEX,
	MEMORY_MODEL_1, // load load，x86 上找不到
	MEMORY_MODEL_2, // store load
	SEQ_FILE_1
};

int simple_seq_init(void);
void simple_seq_fini(void);

#endif /* end of include guard: HACKING_H_PA2UMYTB */
