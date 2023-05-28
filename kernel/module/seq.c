#include <asm/uaccess.h> /* copy_from_user, copy_to_user */
#include <linux/debugfs.h>
#include <linux/errno.h> /* EFAULT */
#include <linux/fs.h>
#include <linux/module.h>
#include <linux/printk.h> /* pr_info */
#include <linux/seq_file.h> /* seq_read, seq_lseek, single_release */
#include <uapi/linux/stat.h> /* S_IRUSR */

static struct dentry *debugfs_file;

static int show(struct seq_file *m, void *v)
{
	seq_printf(m, "ab\ncd\n");
	return 0;
}

static int open(struct inode *inode, struct file *file)
{
	return single_open(file, show, NULL);
}

static const struct file_operations fops = {
	.llseek = seq_lseek,
	.open = open,
	.owner = THIS_MODULE,
	.read = seq_read,
	.release = single_release,
};

int simple_seq_init(void)
{
	debugfs_file =
		debugfs_create_file("martins3-seq", S_IRUSR, NULL, NULL, &fops);
	if (debugfs_file) {
		return 0;
	} else {
		return -EINVAL;
	}
}

void simple_seq_fini(void)
{
	debugfs_remove(debugfs_file);
}
