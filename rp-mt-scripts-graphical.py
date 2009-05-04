#! /usr/bin/env python
"""Main module to create GTK interface to the MT scripts."""

import gtk
import gobject
import subprocess

class ScriptsWindow:
	"""Class to manage the demo window for the pile manager."""
	
	def __init__(self):
		
		self.builder = gtk.Builder()
		self.builder.add_from_file("rp-mt-scripts-interface.glade")
		self.builder.connect_signals(self)
		
		self.window = self.builder.get_object("winMain")
		self.window.show()
		self.filename = self.builder.get_object("filechooserbutton1")
	
	## GTK+ Signal Handlers
	def on_winMain_destroy(self, _widget, _callback_data=None):
		"""Callback to exit mainloop on window destruction."""
		print "destroy signal occurred"
		gtk.main_quit()
	
	## Automatic tab
	def on_btnConfigInstall_clicked(self, _widget, _callback_data=None):
		run("./configure")
			
	## Manual tab
	def on_btnConfigureNoInstall_clicked(self, _widget, _callback_data=None):
		run("scripts/1_mt_scripts_configuration.sh")
	
	def on_btnInstallTbeta_clicked(self, _widget, _callback_data=None):
		run("scripts/install_tbeta_1.1.sh")
	
	def on_btnInstallPocoLocal_clicked(self, _widget, _callback_data=None):
		run("scripts/install_libpoco_workaround_local.sh")
	
	def on_btnInstallPocoGlobal_clicked(self, _widget, _callback_data=None):
		run("scripts/install_libpoco_workaround_local.sh")
	
	def on_btnInstallFlash_clicked(self, _widget, _callback_data=None):
		run("scripts/install_flashplayer_standalone.sh")
	
	def on_btnInstallPyMT_clicked(self, _widget, _callback_data=None):
		run("scripts/install_pymt_hg.sh")
	
	## Update tab
	def on_btnUpdatePyMT_clicked(self, _widget, _callback_data=None):
		run("scripts/update_pymt_hg.sh")
	
	## Run tab
	def on_btnRunTbeta_clicked(self, _widget, _callback_data=None):
		self.tbeta = run("scripts/install_flashplayer_standalone.sh",
			wait=False)
	
	def on_btnRunFlashPlayer_clicked(self, _widget, _callback_data=None):
		run("scripts/run_flashplayer_standalone.sh")
	
	def on_btnRunPyMT_clicked(self, _widget, _callback_data=None):
		run("scripts/run_pymt_hg_examples.sh")
	
	def on_btnRunOtherPy_clicked(self, _widget, _callback_data=None):
		run("python "+self.filename.get_filename())
	
	
		
		
	def main(self):
		"""Start the GTK mainloop"""
		gtk.main()
	
def run(cmdline, show_terminal=True, wait=True):
	if show_terminal:
		cmdline="gnome-terminal -x " + cmdline
	
	process = subprocess.Popen(cmdline)
	
	if wait:
		return process.wait()
	else:
		return process
	
if __name__ == "__main__":
	print __file__
	app = ScriptsWindow()
	app.main()
