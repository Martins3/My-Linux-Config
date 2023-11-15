#include <asm/uaccess.h> /* copy_from_user, copy_to_user */
#include <linux/debugfs.h>
#include <linux/errno.h> /* EFAULT */
#include <linux/fs.h>
#include <linux/module.h>
#include <linux/printk.h> /* pr_info */
#include <linux/seq_file.h> /* seq_read, seq_lseek, single_release */
#include <linux/slab.h>
#include <uapi/linux/stat.h> /* S_IRUSR */

static struct dentry *debugfs_file;

struct student {
	char name[100];
	int id;
};

struct student classmates[] = { { .id = 1, .name = "Alice" },
				{ .id = 2, .name = "Bob" },
				{ .id = 3, .name = "Kelvin" } };

/* Called at the beginning of every read.
 *
 * The return value is passsed to the first show.
 * It normally represents the current position of the iterator.
 * It could be any struct, but we use just a single integer here.
 *
 * NULL return means stop should be called next, and so the read will be empty..
 * This happens for example for an ftell that goes beyond the file size.
 */
static void *start(struct seq_file *s, loff_t *pos)
{
	pr_info("start");
	/* beginning a new sequence? */
	if (*pos == 0) {
		/* yes => return a non null value to begin the sequence */
		return classmates;
	}

	/**
   * 整个执行流程，最后会执行下:
   *
   * [   94.251027] open
   * [   94.251160] start
   * [   94.251161] show
   * [   94.251253] next
   * [   94.251338] show
   * [   94.251421] next
   * [   94.251507] show
   * [   94.251594] next
   * [   94.251680] stop
   * [   94.251856] start
   * [   94.251857] [martins3:start:40]
   * [   94.252140] stop
   */
	pr_info("[martins3:%s:%d] \n", __FUNCTION__, __LINE__);
	/* no => it is the end of the sequence, return end to stop reading */
	*pos = 0;
	return NULL;
}

/* The return value is passed to next show.
 * If NULL, stop is called next instead of show, and read ends.
 *
 * Can get called multiple times, until enough data is returned for the read.
 */
static void *next(struct seq_file *s, void *v, loff_t *pos)
{
	struct student *spos = (struct student *)v + 1;
	*pos += sizeof(struct student);
	pr_info("next");
	if (*pos >= sizeof(classmates))
		return NULL;
	return spos;
}

/* Called at the end of every read. */
static void stop(struct seq_file *s, void *v)
{
	pr_info("stop\n");
}

/* Return 0 means success, SEQ_SKIP ignores previous prints, negative for error.
 */
static int show(struct seq_file *s, void *v)
{
	struct student *spos = v;
	pr_info("show");
	seq_printf(s, "%s %d\n", spos->name, spos->id);
	return 0;
}

static struct seq_operations my_seq_ops = {
	.next = next,
	.show = show,
	.start = start,
	.stop = stop,
};

static int open(struct inode *inode, struct file *file)
{
	pr_info("open\n");
	return seq_open(file, &my_seq_ops);
}

static struct file_operations fops = { .owner = THIS_MODULE,
				       .llseek = seq_lseek,
				       .open = open,
				       .read = seq_read,
				       .release = seq_release };

int simple_seq_init2(void)
{
	debugfs_file = debugfs_create_file("lkmc_seq_file", S_IRUSR, NULL, NULL,
					   &fops);
	if (debugfs_file) {
		return 0;
	} else {
		return -EINVAL;
	}
}

void simple_seq_fini2(void)
{
	debugfs_remove(debugfs_file);
}
