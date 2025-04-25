import os
import shutil

def main():
    # Ensure templates directory exists
    os.makedirs("static/templates", exist_ok=True)
    
    # Template mapping from attached assets to static templates
    template_mapping = [
        ("bubble_sheet_template (2).pdf", "standard_20.pdf"),
        ("bubble_sheet_template (5).pdf", "extended_50.pdf"),
        ("bubble_sheet_template (5).pdf", "comprehensive_100.pdf")
    ]
    
    for source, dest in template_mapping:
        source_path = os.path.join("attached_assets", source)
        dest_path = os.path.join("static/templates", dest)
        
        if os.path.exists(source_path):
            try:
                shutil.copy2(source_path, dest_path)
                print(f"Copied {source_path} to {dest_path}")
            except Exception as e:
                print(f"Error copying {source_path} to {dest_path}: {e}")
        else:
            print(f"Source file not found: {source_path}")

if __name__ == "__main__":
    main()