#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/workqueue.h>

/* #define CREAT_WORKQUEUE */

static unsigned long onesec = HZ;
static void mykmod_work_handler(struct work_struct *w);
static DECLARE_DELAYED_WORK(mykmod_work, mykmod_work_handler);

#ifdef CREAT_WORKQUEUE
static struct workqueue_struct *wq = 0;
static void mykmod_work_handler(struct work_struct *w)
{
	pr_info("mykmod work %u jiffies\n", (unsigned)onesec);
	queue_delayed_work(wq, &mykmod_work, onesec);
}

int my_workqueue_init(void)
{
	if (!wq)
		wq = create_singlethread_workqueue("my_workqueue");
	if (wq)
		queue_delayed_work(wq, &mykmod_work, onesec);

	return 0;
}

void my_workqueue_exit(void)
{
	cancel_delayed_work_sync(&mykmod_work);
	if (wq)
		destroy_workqueue(wq);
}

#else

static void mykmod_work_handler(struct work_struct *w)
{
	pr_info("mykmod work %u jiffies\n", (unsigned)onesec);
	schedule_delayed_work(&mykmod_work, onesec);
}

int my_workqueue_init(void)
{
	schedule_delayed_work(&mykmod_work, onesec);
	return 0;
}

void my_workqueue_exit(void)
{
	cancel_delayed_work_sync(&mykmod_work);
}
#endif
