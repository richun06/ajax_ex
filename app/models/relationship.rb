class Relationship < ApplicationRecord
  # フォローするUserとフォローされるUserへのアソシエーションを区別する
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"
end
