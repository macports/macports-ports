package docking.widgets.filechooser;

import docking.DialogComponentProvider;
import ghidra.util.filechooser.GhidraFileChooserModel;
import ghidra.util.filechooser.GhidraFileFilter;
import java.awt.Component;
import java.awt.Dialog;
import java.awt.FileDialog;
import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;
import java.util.List;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

public class GhidraFileChooser extends DialogComponentProvider {
	private GhidraFileChooserModel model;
	private GhidraFileFilter filter;
	private FileDialog fileDialog;
	private int mode = FILES_AND_DIRECTORIES;

	public static final int FILES_ONLY = 0;
	public static final int DIRECTORIES_ONLY = 1;
	public static final int FILES_AND_DIRECTORIES = 2;

	public GhidraFileChooser(Component parent) {
		this(new LocalFileChooserModel(), parent);
	}

	GhidraFileChooser(GhidraFileChooserModel model, Component parent) {
		super("File Chooser", true, true, true, false);
		this.model = model;
		Component root = SwingUtilities.getRoot(parent);
		if (root instanceof Dialog) {
			fileDialog = new FileDialog((Dialog)root);
		} else {
			fileDialog = new FileDialog((JFrame)root);
		}
	}

	public void setShowDetails(boolean showDetails) {
	}

	public void setFileSelectionMode(int mode) {
		this.mode = mode;
	}

	public void setFileSelectionMode(GhidraFileChooserMode mode) {
		switch (mode) {
		case FILES_ONLY:
			this.mode = 0;
			break;
		case DIRECTORIES_ONLY:
			this.mode = 1;
			break;
		case FILES_AND_DIRECTORIES:
			this.mode = 2;
			break;
		}
	}

	public boolean isMultiSelectionEnabled() {
		return fileDialog.isMultipleMode();
	}

	public void setMultiSelectionEnabled(boolean b) {
		fileDialog.setMultipleMode(b);
	}

	public void setApproveButtonText(String buttonText) {
	}

	public void setApproveButtonToolTipText(String tooltipText) {
	}

	public void setLastDirectoryPreference(String newKey) {
	}

	public File getSelectedFile() {
		show();
		String path = fileDialog.getFile();
		return path != null ? new File(fileDialog.getDirectory(), path) : null;
	}

	public List<File> getSelectedFiles() {
		show();
		return Arrays.asList(fileDialog.getFiles());
	}

	public File getSelectedFile(boolean show) {
		return getSelectedFile();
	}

	public void setSelectedFile(File file) {
		fileDialog.setFile(file != null ? file.getPath() : null);
	}

	public void show() {
		fileDialog.setVisible(true);
	}

	public void close() {
		fileDialog.setVisible(false);
	}

	public File getCurrentDirectory() {
		return new File(fileDialog.getDirectory());
	}

	public void setCurrentDirectory(File directory) {
		fileDialog.setDirectory(directory.getPath());
	}

	public void rescanCurrentDirectory() {
	}

	private class _FilenameFilter implements FilenameFilter {
		@Override
		public boolean accept(File dir, String name) {
			File file = new File(dir, name);
			switch (mode) {
			case DIRECTORIES_ONLY:
				if (file.isFile()) {
					return false;
				}
				break;
			case FILES_AND_DIRECTORIES:
			default:
				break;
			}
			return filter.accept(file, model);
		}
	}

	public void addFileFilter(GhidraFileFilter f) {
	}

	public void setSelectedFileFilter(GhidraFileFilter filter) {
		this.filter = filter;
	}

	public void setFileFilter(GhidraFileFilter filter) {
		this.filter = filter;
	}

	public boolean wasCancelled() {
		return fileDialog.getFile() == null;
	}

	@Override
	public void setTitle(String title) {
		fileDialog.setTitle(title);
	}
}
