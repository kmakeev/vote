# Generated by Django 4.2.5 on 2023-09-25 11:11

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        (
            "vote",
            "0008_rename_registrationproccess_meeting_registrationprocess_and_more",
        ),
    ]

    operations = [
        migrations.RenameField(
            model_name="votingprocess", old_name="answers", new_name="answer",
        ),
    ]
