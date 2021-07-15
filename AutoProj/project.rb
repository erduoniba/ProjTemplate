require 'xcodeproj'
require 'json'

#移除索引
def removeBuildPhaseFilesRecursively(aTarget, aGroup)
    aGroup.files.each do |file|
        aTarget.resources_build_phase.remove_file_reference(file)
    end
    
    aGroup.groups.each do |group|
        removeBuildPhaseFilesRecursively(aTarget, group)
    end
end

#添加索引
def addFilesToGroup(aGroup, full_path, aTarget)
    current_path = full_path
    mGroup = aGroup
    puts "current_path : #{current_path} mGroup : #{mGroup}"
    Dir.foreach(current_path) do |entry|
        filePath = File.join(current_path, entry)
        puts("filePath : #{filePath}")
        # 过滤目录和.DS_Store文件
        if entry != ".DS_Store" && !filePath.to_s.end_with?(".meta") && entry != "." && entry != ".." then
            if File::ftype(filePath) == "directory"
                mGroup = aGroup.find_subpath(File.join(entry), true)
                addFilesToGroup(mGroup, filePath, aTarget)
            else
                # 向group中增加文件引用
                if nil == mGroup.find_subpath(entry)
                    fileReference = mGroup.new_reference(filePath)
                    aTarget.resources_build_phase.add_file_reference(fileReference, true)
                end
            end
        end
    end
end

# parent_path : PGPaySuccess
# target_name : AutoProj
# moudel_path : /Users/denglibing3/HDProject/GithubProject/ProjTemplate/AutoProj/AutoProj/PGPaySuccess
# mapiGroup : PGPaySuccess

fconfig = File.read('moudels.json')
configs = JSON.parse(fconfig)
for project_item in configs do
    proj_path = project_item["proj_path"]
    parent_path = project_item["parent_path"]

    #相对于 ruby文件 .xcodeproj 的路径
    project = Xcodeproj::Project.open(proj_path)
    target = project.targets.first
    project_dir = project.project_dir
    target_name = target.name
    moudel_path = "#{project_dir}/#{target_name}/#{parent_path}"
    
    puts "moudel_path : #{moudel_path} parent_path : #{parent_path} target_name : #{target_name}"

    path = File.join(target_name, parent_path)
    puts "path : #{path}"

    mapiGroup = project.main_group.find_subpath(path, true)
    mapiGroup.remove_from_project
    project.save

    mapiGroup = project.main_group.find_subpath(path, true)
    addFilesToGroup(mapiGroup, moudel_path, target)

    puts "mapiGroup : #{mapiGroup}"

    puts "重组目录结构..."
    project.save
end
